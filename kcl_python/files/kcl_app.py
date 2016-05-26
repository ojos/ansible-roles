#!env python
from __future__ import print_function
import sys
import time
import json
import base64

from logging import (DEBUG, Formatter, getLogger)
from logging.handlers import RotatingFileHandler

from amazon_kclpy import kcl

logger = getLogger(__name__)
logger.setLevel(DEBUG)
formatter = Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler = RotatingFileHandler(
    filename='../../log/kcl/sub.log',
    maxBytes=1024 * 1024 * 100,
    backupCount=5
)
handler.setLevel(DEBUG)
handler.setFormatter(formatter)
logger.addHandler(handler)


class RecordProcessor(kcl.RecordProcessorBase):

    def __init__(self, **kwargs):
        logger.debug('__init__')
        self.checkpoint_error_sleep_seconds = kwargs.get('checkpoint_error_sleep_seconds', 5)
        self.checkpoint_retries = kwargs.get('checkpoint_retries', 5)
        self.checkpoint_freq_seconds = kwargs.get('checkpoint_freq_seconds', 60)
        self.records_per_checkpoint = kwargs.get('records_per_checkpoint', 0)

        self.records_processed = 0
        self.largest_seq = None
        self.last_checkpoint_time = time.time()

    def initialize(self, shard_id):
        logger.debug('initialize')
        # pass

    def checkpoint(self, checkpointer, sequence_number=None):
        for n in range(0, self.checkpoint_retries):
            try:
                checkpointer.checkpoint(sequence_number)
                self.last_checkpoint_time = time.time()
                self.records_processed = 0
                return
            except kcl.CheckpointError as e:
                if 'ShutdownException' == e.value:
                    logger.debug('Encountered shutdown execption, skipping checkpoint')
                    return
                elif 'ThrottlingException' == e.value:
                    if self.checkpoint_retries - 1 == n:
                        logger.error(
                            'Failed to checkpoint after {n} attempts, giving up.'.format(n=n))
                        return
                    else:
                        logger.debug('Was throttled while checkpointing, will attempt again in {s} seconds'.format(
                            s=self.checkpoint_error_sleep_seconds))
                elif 'InvalidStateException' == e.value:
                    logger.error('MultiLangDaemon reported an invalid state while checkpointing.')
                else:
                    logger.exception('Encountered an error while checkpointing')
            time.sleep(self.checkpoint_error_sleep_seconds)

    def process_record(self, data, partition_key, sequence_number):
        logger.debug(data)
        return False

    def should_checkpoint(self):
        if self.checkpoint_freq_seconds:
            return time.time() - self.last_checkpoint_time > self.checkpoint_freq_seconds
        if self.records_per_checkpoint:
            return self.records_processed > self.records_per_checkpoint
        return False

    def process_records(self, records, checkpointer):
        logger.debug('process_records')
        try:
            explicit_checkpoint = False
            for record in records:
                data = base64.b64decode(record.get('data'))
                seq = record.get('sequenceNumber')
                seq = int(seq)
                key = record.get('partitionKey')
                explicit_checkpoint = self.process_record(data, key, seq) is True

                if explicit_checkpoint:
                    self.checkpoint(checkpointer, str(seq))

                self.records_processed += 1
                if self.largest_seq is None or seq > self.largest_seq:
                    self.largest_seq = seq

            should_checkpoint = self.should_checkpoint()
            if should_checkpoint:
                self.checkpoint(checkpointer, str(self.largest_seq))
        except Exception as e:
            logger.exception("Encountered an exception while processing records.")

    def shutdown(self, checkpointer, reason):
        logger.debug('shutdown')
        try:
            if reason == 'TERMINATE':
                logger.info('Was told to terminate, will attempt to checkpoint.')
                self.checkpoint(checkpointer, None)
            else:
                logger.info('Shutting down due to failover. Will not checkpoint.')
        except:
            pass


if __name__ == "__main__":
    kclprocess = kcl.KCLProcess(RecordProcessor(records_per_checkpoint=10))
    kclprocess.run()

#!env python
import kclpy
import json
import os


def logging(text):
    path = '../../log/kcl/python.log'
    if os.path.exists(path):
        with open(path, mode='a') as fh:
            fh.write('%s\n' % text)
    else:
        with open(path, mode='w') as fh:
            fh.write('%s\n' % text)


class MyStreamProcessor(kclpy.RecordProcessor):

    def process_record(self, data, partition_key, sequence_number):
        logging(data)
        return True
        # try:
        #     # assumes the incoming kinesis record is json
        #     data = json.loads(data)
        #     user = data.get("user")

        #     # explicitly return True to force a checkpoint (otherwise the default)
        #     # checkpointing strategy is used
        #     return True

        # except ValueError:
        #     # not valid json
        #     log.error("Invalid json placed on queue, nothing we can do")
        #     return


def main():
    # every_minute_processor = MyStreamProcessor(checkpoint_freq_seconds=60)
    every_hundred_records_processor = MyStreamProcessor(records_per_checkpoint=100)
    kclpy.start(MyStreamProcessor())

# The script that abides by the multi-language protocol. This script will
# be executed by the MultiLangDaemon, which will communicate with this script
# over STDIN and STDOUT according to the multi-language protocol.
executableName = python ./{{ kclpy_executable_file_name }}

# The name of an Amazon Kinesis stream to process.
streamName = {{ kclpy_stream_name }}

# Used by the KCL as the name of this application. Will be used as the name
# of an Amazon DynamoDB table which will store the lease and checkpoint
# information for workers with this application name
applicationName = {{ kclpy_application_name }}

# Users can change the credentials provider the KCL will use to retrieve credentials.
# The DefaultAWSCredentialsProviderChain checks several other providers, which is
# described here:
# http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/DefaultAWSCredentialsProviderChain.html
AWSCredentialsProvider = {{ kclpy_credentials_provider }}

# Appended to the user agent of the KCL. Does not impact the functionality of the
# KCL in any other way.
processingLanguage = {{ kclpy_processing_language }}

# Valid options at TRIM_HORIZON or LATEST.
# See http://docs.aws.amazon.com/kinesis/latest/APIReference/API_GetShardIterator.html#API_GetShardIterator_RequestSyntax
initialPositionInStream = {{ kclpy_initial_position_in_stream }}

# The following properties are also available for configuring the KCL Worker that is created
# by the MultiLangDaemon.

# The KCL defaults to us-east-1
regionName = {{ kclpy_region_name }}

# Fail over time in milliseconds. A worker which does not renew it's lease within this time interval
# will be regarded as having problems and it's shards will be assigned to other workers.
# For applications that have a large number of shards, this msy be set to a higher number to reduce
# the number of DynamoDB IOPS required for tracking leases
failoverTimeMillis = {{ kclpy_failover_time_millis }}

# A worker id that uniquely identifies this worker among all workers using the same applicationName
# If this isn't provided a MultiLangDaemon instance will assign a unique workerId to itself.
#workerId = 

# Shard sync interval in milliseconds - e.g. wait for this long between shard sync tasks.
shardSyncIntervalMillis = {{ kclpy_shard_sync_interval_millis }}

# Max records to fetch from Kinesis in a single GetRecords call.
maxRecords = {{ kclpy_max_records }}

# Idle time between record reads in milliseconds.
idleTimeBetweenReadsInMillis = {{ kclpy_idle_time_between_reads_in_millis }}

# Enables applications flush/checkpoint (if they have some data "in progress", but don't get new data for while)
callProcessRecordsEvenForEmptyRecordList = {{ kclpy_call_process_records_even_for_empty_record_list }}

# Interval in milliseconds between polling to check for parent shard completion.
# Polling frequently will take up more DynamoDB IOPS (when there are leases for shards waiting on
# completion of parent shards).
parentShardPollIntervalMillis = {{ kclpy_parent_shard_poll_interval_millis }}

# Cleanup leases upon shards completion (don't wait until they expire in Kinesis).
# Keeping leases takes some tracking/resources (e.g. they need to be renewed, assigned), so by default we try
# to delete the ones we don't need any longer.
cleanupLeasesUponShardCompletion = {{ kclpy_cleanup_leases_upon_shard_completion }}

# Backoff time in milliseconds for Amazon Kinesis Client Library tasks (in the event of failures).
taskBackoffTimeMillis = {{ kclpy_task_backoff_time_millis }}

# Buffer metrics for at most this long before publishing to CloudWatch.
metricsBufferTimeMillis = {{ kclpy_metrics_buffer_time_millis }}

# Buffer at most this many metrics before publishing to CloudWatch.
metricsMaxQueueSize = {{ kclpy_metrics_max_queue_size }}

# KCL will validate client provided sequence numbers with a call to Amazon Kinesis before checkpointing for calls
# to RecordProcessorCheckpointer#checkpoint(String) by default.
validateSequenceNumberBeforeCheckpointing = {{ kclpy_validate_sequence_number_before_checkpointing }}

# The maximum number of active threads for the MultiLangDaemon to permit.
# If a value is provided then a FixedThreadPool is used with the maximum
# active threads set to the provided value. If a non-positive integer or no
# value is provided a CachedThreadPool is used.
maxActiveThreads = {{ kclpy_max_active_threads }}
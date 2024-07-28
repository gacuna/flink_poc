package com.fabfitfun.flinkpoc;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.cdc.connectors.mysql.source.MySqlSource;
import org.apache.flink.cdc.debezium.JsonDebeziumDeserializationSchema;
import org.apache.flink.connector.base.DeliveryGuarantee;
import org.apache.flink.connector.kafka.sink.KafkaRecordSerializationSchema;
import org.apache.flink.connector.kafka.sink.KafkaSink;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

public class SyncJob {
  public static void main(String[] args) throws Exception {
    MySqlSource<String> mySqlSource = MySqlSource.<String>builder()
        .hostname("localhost")
        .port(3306)
        .databaseList("pushDb") // set captured database
        .tableList("pushDb.users") // set captured table
        .username("root")
        .password("root")
        .serverTimeZone("UTC")
        .deserializer(new JsonDebeziumDeserializationSchema()) // converts SourceRecord to JSON String
        .build();

      KafkaSink<String> kafkaSink = KafkaSink.<String>builder()
        .setBootstrapServers("localhost:9092")
        .setRecordSerializer(KafkaRecordSerializationSchema.builder()
            .setTopic("cdc-pushdb-users")
            .setValueSerializationSchema(new SimpleStringSchema())
            .build()
        )
        .setDeliveryGuarantee(DeliveryGuarantee.AT_LEAST_ONCE)
        .build();

    StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
    // enable checkpoint
    env.enableCheckpointing(3000);
    env
        .fromSource(mySqlSource, WatermarkStrategy.noWatermarks(), "MySQL Source")
        .sinkTo(kafkaSink)
        // set 4 parallel source tasks
        .setParallelism(4)
        //.print()
        .setParallelism(1); // use parallelism 1 for sink to keep message ordering
    env.execute("Print MySQL Snapshot + Binlog");
  }
}

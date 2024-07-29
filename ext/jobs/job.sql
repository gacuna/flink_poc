SET 'table.local-time-zone' = 'UTC';

SET 'table.exec.mini-batch.enabled' = 'true';

SET 'table.exec.mini-batch.allow-latency' = '500 ms';

SET 'table.exec.mini-batch.size' = '1000';

CREATE TABLE ebdb_users (
                            id INT,
                            account_code STRING,
                            password STRING,
                            salt STRING,
                            email STRING,
                            first_name STRING,
                            last_name STRING,
                            uuid BINARY(16),
                            date_created TIMESTAMP(0),
                            date_modified TIMESTAMP(0),
                            PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = '0.0.0.0',
      'port' = '3306',
      'username' = 'root',
      'password' = 'root',
      'database-name' = 'ebdb',
      'table-name' = 'users',
      'server-time-zone' = 'UTC'
      );

CREATE TABLE ebdb_user_woo_users (
                                id INT,
                                user_id INT,
                                woo_user_id INT,
                                PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = '0.0.0.0',
      'port' = '3306',
      'username' = 'root',
      'password' = 'root',
      'database-name' = 'ebdb',
      'table-name' = 'user_woo_users',
      'server-time-zone' = 'UTC'
      );

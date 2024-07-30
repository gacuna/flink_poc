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
      'hostname' = 'mysql-push',
      'port' = '3306',
      'username' = 'cdcuser',
      'password' = 'cdcpass',
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
      'hostname' = 'mysql-push',
      'port' = '3306',
      'username' = 'cdcuser',
      'password' = 'cdcpass',
      'database-name' = 'ebdb',
      'table-name' = 'user_woo_users',
      'server-time-zone' = 'UTC'
      );

CREATE TABLE shop_shop_users (
                                     ID INT,
                                     user_login STRING,
                                     user_pass STRING,
                                     user_nicename STRING,
                                     user_email STRING,
                                     user_url STRING,
                                     user_registered TIMESTAMP(0),
                                     user_activation_key STRING,
                                     user_status INT,
                                     display_name STRING,
                                     PRIMARY KEY (ID) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = 'mysql-push',
      'port' = '3306',
      'username' = 'cdcuser',
      'password' = 'cdcpass',
      'database-name' = 'shop',
      'table-name' = 'shop_users',
      'server-time-zone' = 'UTC'
      );

CREATE VIEW users_raw AS
SELECT *
FROM ebdb_users u
         LEFT JOIN ebdb_user_woo_users uwu ON u.id = uwu.user_id
         LEFT JOIN shop_shop_users su ON su.ID = uwu.woo_user_id;

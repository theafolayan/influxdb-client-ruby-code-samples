puts "Script Started"

require 'influxdb-client'
token = '5hv3oM1KrTdBSqyxc3aJy_fUxnZyQvKUx9cvYJaPMsdEa2yz0uCcIu2WQl7A_EuHYEcJr4u0wJfVYQAHB3Se6w=='
org = 'demo-org'
bucket = 'test-bucket' 
url = 'http://localhost:8086'



client = InfluxDB2::Client.new(url, token, precision: InfluxDB2::WritePrecision::NANOSECOND, use_ssl: false, bucket: bucket, org: org);


## Configuring write options 
write_options = InfluxDB2::WriteOptions.new(write_type: InfluxDB2::WriteType::BATCHING, batch_size: 10, flush_interval: 5_000, max_retries: 3, max_retry_delay: 15_000, exponential_base: 2);

## instatiating the write api
write_api = client.create_write_api(write_options: write_options)

line = "workers_in_warehouse,building=a,floor=one,supervisor=james count=200}"

# using an hash
hash = { name: 'workers_in_warehouse',
         tags: { building: 'main', floor: 1, supervisor: 'james' },
         fields: { count: 213 } 
        }
## using a data point

point = InfluxDB2::Point.new(name: 'workers_in_warehouse')
                            .add_tag('building', 'main')
                            .add_tag('floor', 1)
                            .add_tag('supervisor', 'james')
                            .add_field('count', 201)


## writing to the bucket
write_api.write(data: line);



# Querying the bucket
query_api = client.create_query_api


# result = query_api.query(query: )




puts("## New WRITE FUNCTION ##")

query = 'from(bucket:"' + bucket + '" ) |> range(start: -1h, stop: now())' 

result = query_api.query_raw(query: query)
puts( "Result: #{result})")

puts("## DONE WITH RESULTS##")

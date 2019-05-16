def create_dns_record(ip_address:, hostnames:)
  DNSRecord.create(
    ip_address: ip_address,
    hostnames: hostnames.map do |name|
      Hostname.find_or_initialize_by(name: name)
    end
  )
end

create_dns_record ip_address: '1.1.1.1', hostnames: ['lorem.com', 'ipsum.com', 'dolor.com', 'amet.com']
create_dns_record ip_address: '2.2.2.2', hostnames: ['ipsum.com']
create_dns_record ip_address: '3.3.3.3', hostnames: ['ipsum.com', 'dolor.com', 'amet.com']
create_dns_record ip_address: '4.4.4.4', hostnames: ['ipsum.com', 'dolor.com', 'sit.com', 'amet.com']
create_dns_record ip_address: '5.5.5.5', hostnames: ['dolor.com', 'sit.com']

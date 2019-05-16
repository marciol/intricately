class Api::V1::DNSRecordsController < ApplicationController
  def create
    @dns_record = DNSRecord.new(dns_record_params)
    if @dns_record.save
      render json: {
        id: @dns_record.id
      }, status: :ok
    else
      render json: {
        errors: @dns_record.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def index
    result = DNSRecord.filter_records(
      include_hostnames: params[:include_hostnames],
      exclude_hostnames: params[:exclude_hostnames],
      page: params[:page].to_i == 0 ? 1 : params[:page].to_i
    )

    total = result.total
    records = result.records

    matching_dns_records =
      records.map { |r| {id: r.id, ip_address: r.ip_address.to_s} }

    associated_hostnames =
      records
        .flat_map(&:hostnames)
        .map(&:name)
        .reduce(Hash.new(0)) { |h, v| h[v] += 1; h }

    render json: {
      total_matching_dns_records: total,
      matching_dns_records: matching_dns_records,
      associated_hostnames: associated_hostnames
    }
  end

  private

  def dns_record_params
    params
      .require(:dns_record)
      .permit(:ip_address, hostnames: [])
      .tap do |this|
        this["hostnames"] = this["hostnames"].map do |name|
          Hostname.find_or_initialize_by(name: name)
        end
      end
  end
end

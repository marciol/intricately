class Api::V1::DNSRecordsController < ApplicationController
  def create
    @dns_record = DNSRecord.new(dns_record_params)
    if @dns_record.save
      render json: {
        data: {
          id: @dns_record.id
        },
      }, status: :ok
    else
      render json: {
        errors: @dns_record.errors.full_messages
      }, status: :unprocessable_entity
    end
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

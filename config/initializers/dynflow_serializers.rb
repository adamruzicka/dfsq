#!/usr/bin/env ruby

Rails.application.config.active_job.custom_serializers << ::Dynflow::ActiveJob::Serializer

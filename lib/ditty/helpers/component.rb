# frozen_string_literal: true

require 'active_support'
require 'active_support/inflector'

module Ditty
  module Helpers
    module Component
      include ActiveSupport::Inflector

      def dataset
        search(filtered(policy_scope(settings.model_class)))
      end

      def list
        params['count'] ||= 10
        params['page'] ||= 1

        dataset.select.paginate(params['page'].to_i, params['count'].to_i)
      end

      def heading(action = nil)
        @headings ||= begin
          heading = titleize(demodulize(settings.model_class))
          h = Hash.new(heading)
          h[:new] = "New #{heading}"
          h[:list] = pluralize heading
          h[:edit] = "Edit #{heading}"
          h
        end
        @headings[action]
      end

      def dehumanized
        settings.dehumanized || underscore(heading)
      end

      def base_path
        settings.base_path || "#{settings.map_path}/#{dasherize(view_location)}"
      end

      def filters
        self.class.const_defined?('FILTERS') ? self.class::FILTERS : []
      end

      def searchable_fields
        self.class.const_defined?('SEARCHABLE') ? self.class::SEARCHABLE : []
      end

      def filtered(dataset)
        filters.each do |filter|
          next if [nil, ''].include? params[filter[:name].to_s]
          filter[:field] ||= filter[:name]
          filter[:modifier] ||= :to_s
          dataset = apply_filter(dataset, filter)
        end
        dataset
      end

      def apply_filter(dataset, filter)
        value = params[filter[:name].to_s].send(filter[:modifier])
        return dataset.where(filter[:field] => value) unless filter[:field].to_s.include? '.'

        dataset.where(filter_field(filter) => filter_value(filter))
      end

      def filter_field(filter)
        filter[:field].to_s.split('.').first.to_sym
      end

      def filter_value(filter)
        field = filter[:field].to_s.split('.').last.to_sym
        assoc = filter_association(filter)
        value = params[filter[:name].to_s].send(filter[:modifier])
        value = assoc.associated_dataset.first(field => value)
        value.nil? ? assoc.associated_class.new : value
      end

      def filter_association(filter)
        assoc = filter[:field].to_s.split('.').first.to_sym
        assoc = settings.model_class.association_reflection(assoc)
        raise "Unknown association #{assoc}" if assoc.nil?
        assoc
      end

      def search(dataset)
        return dataset if ['', nil].include?(params['q']) || searchable_fields == []

        filters = searchable_fields.map { |f| Sequel.ilike(f.to_sym, "%#{params[:q]}%") }
        dataset.where Sequel.|(*filters)
      end
    end
  end
end

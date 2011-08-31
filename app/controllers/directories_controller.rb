class DirectoriesController < ApplicationController

	before_filter :may_read_directory_required

	def show
		recall_or_record_sort_order
		@members = User.find(:all,
			:select => 'DISTINCT users.*',
			:include => :professions,
#			:joins => [
#				'LEFT JOIN "user_professions" ON ("users"."id" = "user_professions"."user_id")',
#				'LEFT JOIN "professions" ON ("professions"."id" = "user_professions"."profession_id")'
#			],
			:order => search_order )
	end

protected

	def valid_orders
		HWIA.new(
			:last_name  => nil,
			:title      => nil
		)
	end

	def search_order
		if valid_orders.has_key?(params[:order])
			order_string = if valid_orders[params[:order]].blank?
				params[:order]
#	Only used when order is part of a join.
#	Uncomment if such a sortable column is added.
#			else
#				valid_orders[params[:order]]
			end
			dir = case params[:dir].try(:downcase)
				when 'desc' then 'desc'
				else 'asc'
			end
			[order_string,dir].join(' ')
		else
			nil
		end
	end

	def may_read_directory_required
		current_user.may_read_directory? || access_denied
	end

end

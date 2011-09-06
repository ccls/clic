class DirectoriesController < ApplicationController

	before_filter :may_read_directory_required

	def show
		recall_or_record_sort_order
		conditions = [[]]
		joins = []
		if params[:first_name] and !params[:first_name].blank?
			conditions[0] << 'users.first_name LIKE ?'
			conditions << "%#{params[:first_name]}%"
		end
		if params[:last_name] and !params[:last_name].blank?
			conditions[0] << 'users.last_name LIKE ?'
			conditions << "%#{params[:last_name]}%"
		end
		if params[:profession_id] and !params[:profession_id].blank?
			joins << 'LEFT JOIN "user_professions" ON ("users"."id" = "user_professions"."user_id")'
			joins << 'LEFT JOIN "professions" ON ("professions"."id" = "user_professions"."profession_id")'
			conditions[0] << 'professions.id = ?'
			conditions << params[:profession_id]
		end
		conditions[0] = conditions[0].join(' AND ')
		@members = User.find(:all,
			:select     => 'DISTINCT users.*',
			:conditions => conditions,
			:joins      => joins,
			:include    => :professions,
			:order      => search_order )
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

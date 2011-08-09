require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase

	# a @membership is required so that those group roles will work
	setup :create_a_membership

	assert_access_with_login(:show, { :logins => site_administrators })
	assert_no_access_with_login(:show, { :logins => non_site_administrators })
	assert_no_access_without_login :show
	assert_access_with_https   :show
	assert_no_access_with_http :show

	site_administrators.each do |cu|

		test "should show with subjects and #{cu} login" do
			login_as send(cu)
			random_subject()
			Subject.solr_reindex
			get :show
			assert_response :success
			assert assigns(:search)
			assert_equal 1, assigns(:search).hits.length
		end

	#	%w( world_region country study_name recruitment study_design target_age_group 
		%w( case_control leukemiatype immunophenotype interview_respondent reference_year
			birth_year gender age ethnicity income_quint downs
			mother_education father_education ).each do |p|

			test "should find sole subject with matching param #{p} and #{cu} login" do
				login_as send(cu)
				subject = random_subject()
				Subject.solr_reindex
				get :show, p.to_sym => [subject.send(p)]
				assert_response :success
				assert assigns(:search)
				assert_equal 1, assigns(:search).hits.length
			end

			test "should NOT find sole subject with mismatching param #{p} and #{cu} login" do
				login_as send(cu)
				subject = random_subject()
				Subject.solr_reindex
				get :show, p.to_sym => ["some_bogus_value"]
				assert_response :success
				assert assigns(:search)
				assert_equal 0, assigns(:search).hits.length
			end

#	test with operators

		end

#		%w( father_age_birth mother_age_birth ).each do |p|
#
#		end

	end

protected

	def random_subject(options={})
		Factory(:subject, { 
			:study                => Study.random,
			:case_control         => random_case_control,
			:leukemiatype         => random_leukemiatype,
			:immunophenotype      => random_immunophenotype,
			:interview_respondent => random_interview_respondent,
			:reference_year       => random_reference_year,
			:birth_year           => random_birth_year,
			:gender               => random_gender,
			:age                  => random_age,
			:ethnicity            => random_ethnicity,
			:income_quint         => random_income_quint,
			:downs                => random_downs,
			:mother_education     => random_mother_education,
			:father_education     => random_father_education
#			:father_age_birth 
#			:mother_age_birth
		}.merge(options))
	end

	def random_case_control
		['Case','Control'][rand(2)]
	end
	def random_leukemiatype
		['ALL','AML'][rand(2)]
	end
	def random_immunophenotype
		['Mixed Lineage','Pre B-Cell','T-Cell'][rand(3)]
	end
	def random_interview_respondent
		['Father','Mother'][rand(2)]
	end
	def random_reference_year
		(1995..2010).to_a[rand(16)]
	end
	def random_birth_year
		(1982..2010).to_a[rand(29)]
	end
	def random_gender
		['Male','Female'][rand(2)]
	end
	def random_age
		(0..15).to_a[rand(16)]
	end
	def random_ethnicity
		['Caucasian','Hispanic'][rand(2)]
	end
	def random_income_quint
		['Highest Quintile','Second Quintile','Third Quintile','Fourth Quintile','Lowest Quintile'][rand(5)]
	end
	def random_downs
		['Yes','No'][rand(2)]
	end
	def random_mother_education
		random_education
	end
	def random_father_education
		random_education
	end
	def random_education
		['Some Primary','Some Secondary','Some Tertiary','Tertiary Done'][rand(4)]
	end

end
__END__


5 Father Age Births

    under_20 ( 748 )
    20..29 ( 1152 )
    30..39 ( 1629 )
    40..49 ( 366 )
    over_50 ( 32 )

4 Mother Age Births

    under_20 ( 318 )
    20..29 ( 1774 )
    30..39 ( 1733 )
    40..49 ( 141 )


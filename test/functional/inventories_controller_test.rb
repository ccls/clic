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
		%w( case_control leukemiatype immunophenotype interview_respondent 
			gender age ethnicity income_quint downs
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
				#	NOTE "some_bogus_value" will be converted to an integer when applicable
				#		which means that it will be treated as 0, so removed 0 as option
				#		in random field generators below.
				get :show, p.to_sym => ["some_bogus_value"]
				assert_response :success
				assert assigns(:search)
				assert_equal 0, assigns(:search).hits.length
			end

#	test with AND/OR operators

		end

#	Facets that use ranges.  Tests could be merged if big enough steps
#	need to be numeric ("some_bogus_value".to_i == 0)
#	"some_bogus_value" won't match any of the expected value formats so will be ignored

		%w( reference_year birth_year father_age_birth mother_age_birth ).each do |p|

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
				#	20 should be big enough to be outside the initial range
				get :show, p.to_sym => [(subject.send(p) + 20).to_s]
				assert_response :success
				assert assigns(:search)
				assert_equal 0, assigns(:search).hits.length
			end

		end

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
			:father_education     => random_father_education,
			:father_age_birth     => random_father_age_birth,
			:mother_age_birth     => random_mother_age_birth
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
		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
		#		it within the expected ranges for faceting and filtering
		(1995..2000).to_a[rand(6)]
	end
	def random_birth_year
		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
		#		it within the expected ranges for faceting and filtering
		(1982..2000).to_a[rand(19)]
	end
	def random_gender
		['Male','Female'][rand(2)]
	end
	def random_age
		#	NOTE not using 0 
		(1..15).to_a[rand(15)]
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
	def random_mother_age_birth
		random_age_birth
	end
	def random_father_age_birth
		random_age_birth
	end
	def random_age_birth
		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
		#		it within the expected ranges for faceting and filtering
		(20..30).to_a[rand(11)]
	end

end
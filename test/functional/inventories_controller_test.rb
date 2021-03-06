require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
#
#	def inventory_reader
#		FactoryGirl.create(:membership,
#			:group      => Group.find_by_name('Coordination Group'),
#			:approved   => true,
#			:group_role => GroupRole['reader']
#		).user
#	end
#
#	def self.inventory_readers
#		@inventory_readers ||= ( site_administrators + %w( inventory_reader ) )
#	end
#
#	ASSERT_ACCESS_OPTIONS = { 
#		:actions => [:show],
#		:skip_show_failure => true,
#		:no_redirect_check => true }
#
#	# a @membership is required so that those group roles will work
#	setup :create_a_membership
#
#	assert_access_with_login({    :logins => inventory_readers })
#	assert_no_access_with_login({ :logins => non_site_administrators })
#	assert_no_access_without_login
#
#	inventory_readers.each do |cu|
#
##	run just this one test like so
##	ruby -I.:lib:test -rubygems test/functional/inventories_controller_test.rb -n '/^(test_should_return_to_root_if_solr_server_is_down_and_administrator_login)$/' | unit_diff -u
#
#		test "should return to root if solr server is down and #{cu} login" do
#			login_as send(cu)
#			Subject.stubs(:search).raises(Errno::ECONNREFUSED)
#			get :show
#			assert_not_nil flash[:error]
#			assert_redirected_to root_path
#		end
#
#		test "should show with subjects and #{cu} login" do
#			login_as send(cu)
#			subject = random_subject()
#			get :show
#			assert_found_one(subject)
#		end
#
#		test "should find sole subject with matching exposure category and #{cu} login" do
#			login_as send(cu)
#			subject = random_exposure_subject()
#			get :show, :category => ['Alcohol']
#			assert_found_one(subject)
#		end
#
#		test "should NOT find sole subject with mismatching exposure category and #{cu} login" do
#			login_as send(cu)
#			subject = random_exposure_subject()
#			get :show, :category => ['Tobacco']
#			assert_found_nothing
#		end
#
#
#		#	exposure facets
#		%w( relation_to_child ).each do |p|
#
#			test "should find sole subject ignoring blank exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => 'Arbitrary')
#				get :show, :category => ['Alcohol'], p => ['']
#				assert_found_one(subject)
#			end
#
#			test "should find sole subject with matching exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => 'Arbitrary')
#				get :show, :category => ['Alcohol'], p => ['Arbitrary']
#				assert_found_one(subject)
#			end
#
#			test "should NOT find sole subject with mismatching exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => 'Arbitrary')
#				get :show, :category => ['Alcohol'], p => ['Different']
#				assert_found_nothing
#			end
#
#		end
#
#		#	exposure facet arrays
##		%w( types windows assessments locations_of_use forms_of_contact ).each do |p|
#		%w( types windows locations_of_use forms_of_contact ).each do |p|
#
#			test "should find sole subject ignoring blank exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => ['Arbitrary'])
#				get :show, :category => ['Alcohol'], p => ['']
#				assert_found_one(subject)
#			end
#
#			test "should find sole subject with matching exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => ['Arbitrary'])
#				get :show, :category => ['Alcohol'], p => ['Arbitrary']
#				assert_found_one(subject)
#			end
#
#			test "should NOT find sole subject with mismatching exposure param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_exposure_subject(p => ['Arbitrary'])
#				get :show, :category => ['Alcohol'], p => ['Different']
#				assert_found_nothing
#			end
#
##
##	TODO need to implement operator selection for exposure_search
##
##			test "should find both subjects with matching param #{p} and #{cu} login and operator OR" do
##				pending	#	TODO
##			end
##
##			test "should find neither subject with matching param #{p} and #{cu} login and operator AND" do
##				#	Can only really use the AND operator for items which a subject can have multiple
##				#	This used to be biospecimens, but now only exposures or study attributes will work.
##				#	exposure
##				#		types
##				#		windows
##				#		assessments
##				#		forms_of_contact
##				#		locations_of_use
##				pending	#	TODO
##			end
#
#		end
#
#
#		#	study related facets
##		%w( world_region country study_name recruitment study_design target_age_group ).each do |p|
#		%w( country study_name recruitment study_design ).each do |p|
#
#			test "should find sole subject ignoring blank param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = _random_subject()
##	update_attribute SKIPS validations which may ignore errors
##				subject.study.update_attribute(p,'Arbitrary')
#				subject.study.update_attributes(p => 'Arbitrary')
#				Subject.solr_reindex
#				get :show, p => ['']
#				assert_found_one(subject)
#			end
#
#			test "should find sole subject with matching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = _random_subject()
##	update_attribute SKIPS validations which may ignore errors
##				subject.study.update_attribute(p,'Arbitrary')
#				subject.study.update_attributes(p => 'Arbitrary')
#				Subject.solr_reindex
#				get :show, p => [subject.send(p)]
#				assert_found_one(subject)
#			end
#
#			test "should NOT find sole subject with mismatching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = _random_subject()
##	update_attribute SKIPS validations which may ignore errors
##				subject.study.update_attribute(p,'Arbitrary')
#				subject.study.update_attributes(p => 'Arbitrary')
#				Subject.solr_reindex
#				get :show, p => ["some_bogus_value"]
#				assert_found_nothing
#			end
#
#		end
#
#
#		#	basic subject facets
#		%w( case_status leukemia_type immunophenotype 
#			gender ethnicity household_income down_syndrome
#			mother_education father_education ).each do |p|
#
#			test "should find sole subject ignoring blank param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				get :show, p => ['']
#				assert_found_one(subject)
#			end
#
#			test "should find sole subject with matching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				get :show, p => [subject.send(p)]
#				assert_found_one(subject)
#			end
#
#			test "should NOT find sole subject with mismatching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				#	NOTE "some_bogus_value" will be converted to an integer when applicable
#				#		which means that it will be treated as 0, so removed 0 as option
#				#		in random field generators below.
#				get :show, p => ["some_bogus_value"]
#				assert_found_nothing
#			end
#
#			%w( AND OR ).each do |op|
#
#				test "should find sole subject ignoring blank param #{p} and #{cu} login and ignore operators #{op}" do
#					login_as send(cu)
#					subject = random_subject()
#					get :show, p => [''], "#{p}_op" => op
#					assert_found_one(subject)
#				end
#
#				test "should find sole subject with matching param #{p} and #{cu} login and ignore operator #{op}" do
#					login_as send(cu)
#					subject = random_subject()
#					get :show, p => [subject.send(p)], "#{p}_op" => op
#					assert_found_one(subject)
#				end
#
#			end
#
#			test "should find both subjects with matching param #{p} and #{cu} login and operator OR" do
#				login_as send(cu)
#				s1 = random_subject()
#				s2 = random_subject()		#	TODO No guarantee to be different
#				get :show, p => [s1.send(p),s2.send(p)], "#{p}_op" => 'OR'
#				assert_response :success
#				assert assigns(:search)
#				assert_equal 2, assigns(:search).hits.length
#				found = assigns(:search).hits.collect(&:instance)
#				assert found.include?(s1)
#				assert found.include?(s2)
#			end
#
##			test "should find neither subject with matching param #{p} and #{cu} login and operator AND" do
##				#	Can only really use the AND operator for items which a subject can have multiple
##				#	This used to be biospecimens, but now only exposures or study attributes will work.
##				#	study
##				#		principal_investigators	#	not used, so nothing for studies really
##				#	exposure
##				#		types
##				#		windows
##				#		assessments
##				#		forms_of_contact
##				#		locations_of_use
##				pending	#	TODO
##			end
#
#		end
#
##	Facets that use ranges.  Tests could be merged if big enough steps
##	need to be numeric ("some_bogus_value".to_i == 0)
##	"some_bogus_value" won't match any of the expected value formats so will be ignored
#
#		#	range related subject facets
#		%w( age reference_year birth_year father_age mother_age ).each do |p|
#
#			test "should find sole subject ignoring blank param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				get :show, p => ['']
#				assert_found_one(subject)
#			end
#
#			test "should find sole subject with matching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				get :show, p => [subject.send(p)]
#				assert_found_one(subject)
#			end
#
#			test "should NOT find sole subject with mismatching param #{p} and #{cu} login" do
#				login_as send(cu)
#				subject = random_subject()
#				#	20 should be big enough to be outside the initial range
#				get :show, p => [(subject.send(p) + 20).to_s]
#				assert_found_nothing
#			end
#
#		end
#
#	end
#
#protected
#
#	def assert_found_one(subject)
#		assert_response :success
#		assert assigns(:search)
#		assert_equal 1, assigns(:search).hits.length
#		assert_equal( subject, assigns(:search).hits.first.instance )
#	end
#
#	def assert_found_nothing
#		assert_response :success
#		assert assigns(:search)
#		assert_equal 0, assigns(:search).hits.length
#	end
#
#	def random_subject(options={})
#		subject = _random_subject(options)
#		Subject.solr_reindex
#		subject
#	end
#
#	def random_exposure_subject(options={})
#		subject = _random_subject()
#		subject.study.exposures.create!({:category => 'Alcohol'}.merge(options))
#		Exposure.solr_reindex
#		Subject.solr_reindex
#		subject
#	end
#
#	def _random_subject(options={})
#		FactoryGirl.create(:subject, { 
#			:study                => Study.random,
#			:case_status          => random_case_status,
#			:leukemia_type        => random_leukemia_type,
#			:immunophenotype      => random_immunophenotype,
#			:interview_respondent => random_interview_respondent,
#			:reference_year       => random_reference_year,
#			:birth_year           => random_birth_year,
#			:gender               => random_gender,
#			:age                  => random_age,
#			:ethnicity            => random_ethnicity,
#			:household_income     => random_household_income,
#			:down_syndrome        => random_down_syndrome,
#			:mother_education     => random_mother_education,
#			:father_education     => random_father_education,
#			:father_age           => random_father_age,
#			:mother_age           => random_mother_age
#		}.merge(options))
#	end
#
#	def random_case_status
#		['Case','Control'][rand(2)]
#	end
#	def random_leukemia_type
#		['ALL','AML'][rand(2)]
#	end
#	def random_immunophenotype
#		['Mixed Lineage','Pre B-Cell','T-Cell'][rand(3)]
#	end
#	def random_interview_respondent
#		['Father','Mother'][rand(2)]
#	end
#	def random_reference_year
#		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
#		#		it within the expected ranges for faceting and filtering
#		(1995..2000).to_a[rand(6)]
#	end
#	def random_birth_year
#		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
#		#		it within the expected ranges for faceting and filtering
#		(1982..2000).to_a[rand(19)]
#	end
#	def random_gender
#		['Male','Female'][rand(2)]
#	end
#	def random_age
#		#	NOTE not using 0 
#		(1..15).to_a[rand(15)]
#	end
#	def random_ethnicity
#		['Caucasian','Hispanic'][rand(2)]
#	end
#	def random_household_income
#		['Highest Quintile','Second Quintile','Third Quintile','Fourth Quintile','Lowest Quintile'][rand(5)]
#	end
#	def random_down_syndrome
#		['Yes','No'][rand(2)]
#	end
#	def random_mother_education
#		random_education
#	end
#	def random_father_education
#		random_education
#	end
#	def random_education
#		['Some Primary','Some Secondary','Some Tertiary','Tertiary Done'][rand(4)]
#	end
#	def random_mother_age
#		random_parent_age
#	end
#	def random_father_age
#		random_parent_age
#	end
#	def random_parent_age
#		#	NOTE keeping this low enough that adding 10 or 20 to it will still keep
#		#		it within the expected ranges for faceting and filtering
#		(20..30).to_a[rand(11)]
#	end
#
end

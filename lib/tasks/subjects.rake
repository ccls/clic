require 'fastercsv'

#	Copied from actionpack/lib/action_view/helpers/text_helper.rb
def pluralize(count, singular, plural = nil)
	"#{count || 0} " + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
end

namespace :app do
namespace :subjects do

	task :destroy_all => :environment do
		puts "Destroying all subjects."
		Sunspot.remove_all!(Subject)
		Subject.destroy_all
	end

	desc "Destroy and re-import the subjects from csv file."
	task :import => :destroy_all do
		puts "Importing all subjects from csv file."

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("CCLS_Aust_Covariate_sample.csv", 'rb',{
			:headers => true })).each do |line|
			puts "Processing subject line #{f.lineno}:#{line['study_name']}"

			study = Study.find_by_name( line['study_name'] )
			raise "Study not found with name:#{line['study_name']}" unless study

			study.subjects.create!({
				:clic_id          => line['CLIC_ID'],
				:case_control     => line['case_control'],
				:leukemiatype     => ((line['leukemiatype'].blank?) ? "NS" : line['leukemiatype']),
				:immunophenotype  => ((line['immunophenotype'].blank?) ? "NS" : line['immunophenotype']),
				:interview_respondent => line['interview_respondent'],
				:reference_year   => line['reference_year'],
				:birth_year       => line['child_birthYEAR'],
				:gender           => line['child_gender'],
				:age              => line['child_age'],
				:ethnicity        => ((line['child_ethnicity'].blank?) ? "NS" : line['child_ethnicity']),
				:mother_age_birth => line['mother_age_birth'],
				:father_age_birth => line['father_age_birth'],
				:income_quint     => ((line['income_quint'].blank?) ? "NS" : line['income_quint']),
				:downs            => ((line['downs'].blank?) ? "NS" : line['downs']),
				:mother_education => ((line['mother_education'].blank?) ? "NS" : line['mother_education']),
				:father_education => ((line['father_education'].blank?) ? "NS" : line['father_education'])
			})

#break if f.lineno > 100
		end
		puts "Loaded #{pluralize(Subject.count,'subject')}."
	end	#	task :import => :destroy_all do

end	#	namespace :subjects do
end	#	namespace :app do

__END__

"CLIC_ID","study_name",
"case_control",
"leukemiatype",
"immunophenotype",
"interview_respondent",
"reference_year",
"child_birthYEAR",
"child_gender",
"child_age",
"child_ethnicity",
"mother_age_birth",
"father_age_birth",
"income_quint",
"downs",
"mother_education",
"father_education"

00000001,"AUS","Case","ALL","T-Cell","Mother",2003,1994,"Male",9,"Caucasian",31,34,"Third Quintile","No","Tertiary Done","Tertiary Done"
00000002,"AUS","Case","ALL","Pre B-Cell","Mother",2003,1999,"Male",3,"Not Classifiable",32,.,"Lowest Quintile","No","Some Secondary",""
00000003,"AUS"


Blanks are bad.  Don't do blanks.  Cause blanks are bad.  Ok.

RSolr::RequestError (Solr Response: orgapachelucenequeryParserParseException_Cannot_parse_leukemiatype_s_Encountered_____at_line_1_column_16_Was_expecting_one_of_____NOT______________________________QUOTED______TERM______PREFIXTERM______WILDTERM__________________NUMBER______TERM____________):
  rsolr (0.12.1) lib/rsolr/connection/requestable.rb:39:in `request'
  rsolr (0.12.1) lib/rsolr/client.rb:34:in `request'
  sunspot (1.2.1) lib/sunspot/search/abstract_search.rb:35:in `execute'
  /Library/Ruby/Gems/1.8/gems/sunspot_rails-1.2.1/lib/sunspot/rails/searchable.rb:306:in `solr_execute_search'
  /Library/Ruby/Gems/1.8/gems/sunspot_rails-1.2.1/lib/sunspot/rails/searchable.rb:139:in `search'
  app/controllers/inventories_controller.rb:6:in `show'



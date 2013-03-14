require 'test_helper'

#	for assert_select
#require 'action_controller/assertions/selector_assertions'
require 'action_dispatch/testing/assertions/selector'

class UserMailerTest < ActionMailer::TestCase
	#	for assert_select
#	include ActionController::Assertions::SelectorAssertions
	include ActionDispatch::Assertions::SelectorAssertions

	test "confirm_email" do
		user = Factory(:user)
		email = UserMailer.confirm_email(user)
		html = HTML::Document.new(email.body.encoded).root
		assert_select html, 'a', :count => 1,
			:text => /http.*confirm_email\/#{user.perishable_token}$/,
			:href => /http.*confirm_email\/#{user.perishable_token}$/
	end

	test "forgot_password" do
		user = Factory(:user)
		email = UserMailer.forgot_password(user)
		html = HTML::Document.new(email.body.encoded).root
		assert_select html, 'a', :count => 1,
			:text => /http.*password_resets\/#{user.perishable_token}\/edit/,
			:href => /http.*password_resets\/#{user.perishable_token}\/edit/
	end

	test "new_user_email" do
		user = Factory(:user)
		email = UserMailer.new_user_email(user)
		html = HTML::Document.new(email.body.encoded).root
		assert_select html, 'a', :count => 1, 
			:text => user.username,
			:href => /http.*users\/#{user.id}$/
		assert_select html, 'a', :count => 1, 
			:text => 'memberships', 
			:href => /http.*memberships/
	end

end

__END__

User Mailer confirm_email: <p>You have submitted an application to be a member of the CLIC restricted access website. Please confirm your username by clicking on the link below or copy and paste the link into a browser.</p>

<a href="http://dev.sph.berkeley.edu:3000/confirm_email/KUuKmnWBiGzg1tZ0DfC5">http://dev.sph.berkeley.edu:3000/confirm_email/KUuKmnWBiGzg1tZ0DfC5</a>

<p>If you have not requested membership or if this email was sent to you in error, please contact us at clic_centraloffice@berkeley.edu.</p>
.


User Mailer forgot_password: <p>We received a request to have your CLIC password reset.  If you made this request, please click on the link below or copy and paste the link into a browser.</p>

<a href="http://dev.sph.berkeley.edu:3000/password_resets/l7CpOAT4MoItz9RkCXe/edit">http://dev.sph.berkeley.edu:3000/password_resets/l7CpOAT4MoItz9RkCXe/edit</a>

<p>If you did not make this request, disregard this email.</p>
.


User Mailer new_user_email: <p>A new CLIC user, <a href="http://dev.sph.berkeley.edu:3000/users/1">username3</a>, was just created.</p>


<p>This user has not requested any memberships yet.</p>


<p>Convenience link to <a href="http://dev.sph.berkeley.edu:3000/memberships">memberships</a> for approval.</p>
.


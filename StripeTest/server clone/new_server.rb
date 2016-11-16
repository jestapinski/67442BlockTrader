require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'yaml'
require 'json'
require 'stripe'

class Server < Sinatra::Base

  configure do
    config = YAML::load(File.open('config.yml'))

    set :api_key, config['api_key']
    set :client_id, config['client_id']

    options = {
      :site => 'https://connect.stripe.com',
      :authorize_url => '/oauth/authorize',
      :token_url => '/oauth/token'
    }

    set :client, OAuth2::Client.new(settings.client_id, settings.api_key, options)
  end

  get '/' do
    erb :index
  end

  get '/authorize' do
    params = {
      :scope => 'read_write'
    }

    # Redirect the user to the authorize_uri endpoint
    url = settings.client.auth_code.authorize_url(params)
    redirect url
  end

  get '/oauth/callback' do
    # Pull the authorization_code out of the response
    # begin
      code = params[:code]

      # Make a request to the access_token_uri endpoint to get an access_token
      
      @resp = settings.client.auth_code.get_token(code, :params => {:scope => 'read_write'})
      print @resp
      @access_token = @resp.params['stripe_user_id']

      if not(@access_token.nil?)
        redirect "smartappbanner://#{@access_token}"
      else
        redirect "http://www.google.com"
      end
    # rescue Exception => e
    #   @msg = e.to_s.gsub(/[^0-9a-z ]/i, '')
    #   @final = "error"
    #   redirect "http://www.google.com/#{@msg}"#{@msg}" #{@msg}"
    # end


    # # puts response.nil?

    # # @user_id = response.body.stripe_user_id
    # # puts response.body

    # if response.nil? then redirect "smartappbanner://#{@access_token}"
    # else redirect "smartappbanner://#{response.body.stripe_user_id}"

    # Use the access_token as you would a regular live-mode API key
    # TODO: Stripe logic
    #redirect "smartappbanner://#{@access_token}"
    #erb :callback
  end
end

Server.run!

# Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']

# use Rack::Session::EncryptedCookie,
#   :secret => 'replace_me_with_a_real_secret_key' # Actually use something secret here!

# get '/' do
#   status 200
#   return "Great, your backend is set up. Now you can configure the Stripe example iOS apps to point here."
# end

# post '/charge' do
#   authenticate!
#   # Get the credit card details submitted by the form
#   source = params[:source]

#   # Create the charge on Stripe's servers - this will charge the user's card
#   begin
#     charge = Stripe::Charge.create(
#       :amount => params[:amount], # this number should be in cents, passed from API Client
#       :currency => "usd",
#       :customer => @customer.id,
#       :source => source,
#       :description => "Example Charge"
#       :destination => params[:finalDestID] #Passed in from iOS client
#     )
#   rescue Stripe::StripeError => e
#     status 402
#     return "Error creating charge: #{e.message}"
#   end

#   status 200
#   return "Charge successfully created"
# end

# # Gets the customer object using Stripe API
# get '/customer' do
#   authenticate!
#   status 200
#   content_type :json
#   @customer.to_json
# end

# post '/customer/sources' do
#   authenticate!
#   source = params[:source]

#   # Adds the token to the customer's sources
#   begin
#     @customer.sources.create({:source => source})
#   rescue Stripe::StripeError => e
#     status 402
#     return "Error adding token to customer: #{e.message}"
#   end

#   status 200
#   return "Successfully added source."
# end

# post '/customer/default_source' do
#   authenticate!
#   source = params[:source]

#   # Sets the customer's default source
#   begin
#     @customer.default_source = source
#     @customer.save
#   rescue Stripe::StripeError => e
#     status 402
#     return "Error selecting default source: #{e.message}"
#   end

#   status 200
#   return "Successfully selected default source."
# end

# def authenticate!
#   # This code simulates "loading the Stripe customer for your current session".
#   # Your own logic will likely look very different.
#   return @customer if @customer
#   if session.has_key?(:customer_id)
#     customer_id = session[:customer_id]
#     begin
#       @customer = Stripe::Customer.retrieve(customer_id)
#     rescue Stripe::InvalidRequestError
#     end
#   else
#     begin
#       @customer = Stripe::Customer.create(:description => "iOS SDK example customer")
#     rescue Stripe::InvalidRequestError
#     end
#     session[:customer_id] = @customer.id
#   end
#   @customer
# end

# # This endpoint is used by the Obj-C example to complete a charge.
# post '/charge_card' do
#   # Get the credit card details submitted by the form
#   token = params[:stripe_token]

#   # Create the charge on Stripe's servers - this will charge the user's card
#   begin
#     charge = Stripe::Charge.create(
#       :amount => params[:amount], # this number should be in cents
#       :currency => "usd",
#       :card => token,
#       :description => "Example Charge"
#       :destination => params[:finalDestID] #Trying to get this to work as expected, this is the first step
#       #Believe other_cust is passed in from iOS client
#     )
#   rescue Stripe::StripeError => e
#     status 402
#     return "Error creating charge: #{e.message}"
#   end

#   status 200
#   return "Charge successfully created"
# end

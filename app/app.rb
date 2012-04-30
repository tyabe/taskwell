class Taskwell < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  get '/' do
    render :index
  end

  get '/new' do
    @project = Project.new
    render 'project/new'
  end

  post '/new' do
    @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect "/#{@project.token}"
    else
      render 'project/new'
    end

  end

  get '/', with: :token do
    @project = Project.find_by_token(params[:token])
    @new_task = @project.tasks.new

    @today_tasks = @project.tasks.where(due_date: Date.today)
    @tomorrow_tasks = @project.tasks.where(due_date: Date.today + 1)
    @someday_tasks = @project.tasks.where("due_date IS NULL OR due_date < ?", Date.today)

    render 'project/show'
  end

  delete '/', with: :token do
    project = Project.find_by_token(params[:token])
    project.destroy

    redirect '/'
  end

  post "/:token/tasks" do
    project = Project.find_by_token(params[:token])
    new_task = project.tasks.new(params[:task])
    new_task.due_date = nil
    new_task.due_date = Date.today if params.key?('today')
    new_task.due_date = Date.today + 1 if params.key?('tomorrow')
    new_task.save

    redirect "/#{project.token}"
  end

  delete "/:token/tasks/:id" do
    project = Project.find_by_token(params[:token])
    task = project.tasks.find(params[:id])
    task.destroy

    redirect "/#{project.token}"
  end

  put "/:token/tasks/:id" do
    project = Project.find_by_token(params[:token])
    task = project.tasks.find(params[:id])
    task.due_date = nil
    task.due_date = Date.today if params.key?('today')
    task.due_date = Date.today + 1 if params.key?('tomorrow')
    task.save

    redirect "/#{project.token}"
  end

  post "/:token/sort" do
    project = Project.find_by_token(params[:token])
    params['positions'].split(',').each_with_index do |id, index|
      task = project.tasks.find(id)
      task.position = index
      task.due_date = case params['type']
                      when 'today'
                        Date.today
                      when 'tomorrow'
                        Date.today + 1
                      else
                        nil
                      end
      task.save
    end
  end

  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
  # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
  # set :public_folder, "foo/bar" # Location for static assets (default root/public)
  # set :reload, false            # Reload application files (default in development)
  # set :default_builder, "foo"   # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"       # Set path for I18n translations (default your_app/locales)
  # disable :sessions             # Disabled sessions by default (enable if needed)
  # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #
end

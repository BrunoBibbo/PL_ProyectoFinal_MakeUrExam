$:.unshift "."
require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/flash'
require 'pl0_program'
require 'auth'
require 'pp'

enable :sessions
set :session_secret, '*&(^#234)'
set :reserved_words, %w{grammar test login auth}

helpers do
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? 'class = "current"' : ''
  end
end

get '/index' do
  erb :index
end

get '/Crear_examen' do
  @programs = PL0Program.all
  erb :Crear_examen
end


get '/:selected?' do |selected|
  puts "*************@auth*****************"
  puts session[:name]
  pp session[:auth]
  programs = PL0Program.all
  pp programs
  puts "selected = #{selected}"
  c  = PL0Program.first(:name => selected)
  source = if c then c.source else "" end
  erb :index,
      :locals => { :programs => programs, :source => source }

end


post '/Crear_examen/save' do
  pp params
  name = params[:fname]

  if session[:auth] # authenticated
    if settings.reserved_words.include? name  # check it on the client side
      flash[:notice] = 
        %Q{<div class="error">No se puede guardar el archivo con nombre '#{name}'.</div>}
      redirect back
    else 
	  
      c  = PL0Program.first(:name => name)
      if c
        c.source = params["input"]
        c.user = session[:name]
        c.provider = session[:provider]
        c.save
      else
        c = PL0Program.new
        c.name = params["fname"]
        c.source = params["input"]
        c.user = session[:name]
        c.provider = session[:provider]
        c.save 
      end
	  flash[:notice] = 
        %Q{<div class="success">Archivo guardado como #{c.name} por #{session[:name]}.</div>}
      pp c
      redirect to '/Crear_examen'
    end
  else
    flash[:notice] = 
      %Q{<div class="error">No estás autenticado.<br />
         Inicia sesión con Google, Facebook o Github.
         </div>}
    redirect back
  end
end



post '/Crear_examen/delete' do
  pp params
  name = params[:fname]

  if session[:auth] # authenticated
    if settings.reserved_words.include? name  # check it on the client side
      flash[:notice] = 
        %Q{<div class="error">No se puede eliminar el archivo con nombre '#{name}'.</div>}
      redirect back
    else 
      c  = PL0Program.first(:name => name)

        if c 
          c.name = params["fname"]   
          c.source = params["input"]
          c.destroy

        flash[:notice] = 
        %Q{<div class="success">Archivo #{c.name} eliminado por #{session[:name]}.</div>}
        end

      pp c
      redirect '/Crear_examen'
    end
  else
    flash[:notice] = 
      %Q{<div class="error">No estás autenticado.<br />
         Inicia sesión con Google, Facebook o Github.
         </div>}
    redirect back
  end
end


post '/access' do
  pp params
  name = params[:fname]

  if session[:auth] # authenticated
    redirect '/Crear_examen'
  else
      flash[:notice] = 
      %Q{<div class="error">No estás autenticado.<br />
         Inicia sesión con Google, Facebook o Github.
         </div>}
      redirect '/'
  end
end
require 'sinatra'
require 'mysql2'
require './Classes.rb'

after do
    ActiveRecord::Base.connection.close
end
configure do
  enable :sessions
#  session[:admin]=flase
end


get '/' do
  erb:start
  if session[:user_name]==nil
    redirect to('/login')
  else
    redirect to('/getMassages')
  end
end

get '/login' do
  erb:login
end

get '/signup' do
  erb:signup
end

post '/login' do
  user=User.find_by(user_name:params[:username])
  if user==nil
    @hint='没有这个用户名，请确认后再输入！'
    erb:loginError
  else
    if user.password!=params[:password]
      @hint='用户密码不正确，请确认后再输入！'
      erb:loginError
    else
    #  session[:admin]=true
      session[:user_name]=params[:username]
      session[:user_id]=user.user_id
      redirect to('getMassages')
    end
  end
end


post '/signup' do
  user=User.create(user_name:params[:username],password:params[:password],password_confirmation:params[:password_confirmation])
  if user.valid?
    redirect to('/login')
  else @hint =user.errors.messages
  erb:signupError
  end
end


get '/getMassages'do
  if session[:user_name]==nil
      redirect to('/login')
  else
    u=User.all
    m=Message.order(:create_at)
    @massages=m
    @users=u
    erb:getMassages
  end
end



post '/delete' do
  if session[:user_name]==nil
    redirect to('/login')
  else
    del=DealMassage.new()
    i,s=del.delete_at(params[:hiddenid].to_i)
    @id=params[:hiddenid].to_i
    @s=s
    erb :delete
  end
end



get '/delete/:id' do
  if session[:user_name]==nil
      redirect to('/login')
  else
    s=params['id']
    array=s.split(" ")
    del=DealMassage.new()
    @cnt,@res=del.delete(array)
    erb :delete_array
  end
end


post '/add' do
  if session[:user_name]==nil
    redirect to('/login')
  else
    message=Message.create(content:params[:massage],user_id:session[:user_id],create_at:Time.new)
    if message.valid?
      u=User.find(session[:user_id])
      u.messages << message
      @id=message.id
      @author_id=message.user_id
      @massage=message.content
      erb :addSuccess
    else
      @error =message.errors.messages
      erb :addError
    end
  end
end


get '/search' do
  if session[:user_name]==nil
    redirect to('/login')
  else
    if params[:search_by]=="1"
      if params[:id]==nil
        @hint="请输入留言id"
        @flag=0
      elsif params[:id].length==0
        @hint="请输入留言id"
        @flag=0
      else
        search=DealMassage.new()
        @flag,@hint=search.search_byid(params[:id].chomp.to_i)
      end
    elsif params[:search_by]=="2"
      if params[:author]==nil
        @hint="请输入留言者姓名"
        @flag=0
      elsif params[:author].length==0
        @hint="请输入留言者姓名"
        @flag=0
      else
        search=DealMassage.new()
        @flag,@hint=search.search_byauthor(params[:author].chomp.to_s)
        if @flag==2
          if params[:choice].to_i==1
            @hint=@hint.order(:id)
          elsif params[:choice].to_i==2
            @hint=@hint.order(:create_at)
          end
        end
      end
    end
    @id=params[:id]
    @author=params[:author]
    erb :search
  end
end


post '/passwordChange' do
  if session[:user_name]==nil
    redirect to('/login')
  else
    user=User.find(session[:user_id])
    if(user.password==params[:curpassword])
      if(params[:newpassword]==params[:newpassword_confirmation])
        user.password=params[:newpassword]
        user.save
        @flag=1
        @hint="修改成功！"
      else
        @flag=0
        @hint ="新密码两次输入不一致，请确认后再输入！"
      end
    else
      @flag=0
      @hint="当前密码输入不正确，请确认后再输入！"
    end
    erb :passChange
  end
end


get '/PersonalMess'do
  if session[:user_name]==nil
    redirect to('/login')
  else
    user=User.find(session[:user_id])
    @user_id=session[:user_id]
    @user_name=session[:user_name]
    search=DealMassage.new()
    @flag,@messages=search.search_byauthor(session[:user_name])
    erb :personalMess
  end
end

get '/logout'do
  if session[:user_name]==nil
    redirect to('/login')
  else
  #  session[:admin]=false
    session[:user_name]=nil
    redirect to('/login')
  end
end

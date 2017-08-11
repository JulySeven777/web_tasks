require 'sinatra'
require 'mysql2'
load 'Classes.rb'


configure do
  enable :sessions
end


get '/' do
  session[:admin]=false
  erb:start
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
      session[:admin]=true
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
  if session[:admin] ==false
      redirect to('/')
  else
    u=User.all
    m=Message.order(:create_at)
    @massages=m
    @users=u
    erb:getMassages
  end
end



post '/delete' do
  del=DealMassage.new()
  i,s=del.delete_at(params[:hiddenid].to_i)
  @id=params[:hiddenid].to_i
  @s=s
  erb :delete
end



get '/delete/:id' do
  s=params['id']
  array=s.split(" ")
  del=DealMassage.new()
  @cnt,@res=del.delete(array)
  erb :delete_array
end


post '/add' do
  message=Message.create(content:params[:massage],user_id:session[:user_id],create_at:Time.new)
  if message.valid?
    @id=message.id
    @author_id=message.user_id
    @massage=message.content
    erb :addSuccess
  else
    @error =message.errors.messages
    erb :addError
  end
end


get '/search' do
  if params[:id].length<=0&&params[:author].length<=0
    @hint="请输入留言id或留言者姓名"
    @flag=0
  elsif params[:id].length!=0&&params[:author].length==0
    search=DealMassage.new()
    @flag,@hint=search.search_byid(params[:id].chomp.to_i)
  elsif params[:id].length==0&&params[:author].length!=0
    search=DealMassage.new()
    @flag,@hint=search.search_byauthor(params[:author].chomp.to_s)
    if(@flag==2)
      if(params[:choice].to_i==1)
        @hint=@hint.order(:id)
      elsif params[:choice].to_i==2
        @hint=@hint.order(:create_at)
      end
    end
  end
  @id=params[:id]
  @author=params[:author]
  erb :search
end


post '/passwordChange' do
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


get '/PersonalMess'do
  user=User.find(session[:user_id])
  @user_id=session[:user_id]
  @user_name=session[:user_name]
  search=DealMassage.new()
  @flag,@messages=search.search_byauthor(session[:user_name])
  erb :personalMess
end

get '/logout'do
  session[:admin]=false
  redirect to('/login')
end

load 'messageclass.rb'

require 'sinatra'
get '/' do
		a1=$messageArray.sort_by{|a| a.time.to_s.downcase}
		@massages=a1
    erb :getMassages
end

post '/add' do
	if params[:massage].to_s.length>=10&&params[:author].length>0
		addV=DealMassage.new()
		id=addV.add_mas(params[:author],params[:massage])
		@id=id
		@author=params[:author]
		@massage=params[:massage]
		erb :success
	else
		if params[:author].length<=0
			 @error='必须有留言者姓名！'
		else @error='留言长度必须不小于10！'
		end
		erb :addError
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




get '/search' do
	if params[:id].length<=0&&params[:author].length<=0
		  @hint="请输入留言id或留言者姓名"
			@flag=0
	elsif params[:id].length!=0&&params[:author].length==0
		search=DealMassage.new()
		@flag,@hint=search.search_byid(params[:id].chomp.to_i)
	elsif params[:id].length==0&&params[:author].length!=0
		search=DealMassage.new()
		@flag,@hinSt=search.search_byauthor(params[:author].chomp.to_s)
		if(@flag==2)
			if(params[:choice].to_i==1)
				@hint=sort_byid(@hint)
			elsif params[:choice].to_i==2
				@hint=sort_bytime(@hint)
			end
		end
	end
	@id=params[:id]
	@author=params[:author]
	erb :search
end

require 'active_record'
require 'mysql2'
require 'yaml'

dbconfig = YAML::load(File.open('dbconnection.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

#ActiveRecord::Base.establish_connection(
#  :adapter  => 'mysql2',
#  :database => 'task3',   #oracle service name
#  :username => 'root',
#  :password => 'root',
#  :pool => 105
#)


class User < ActiveRecord::Base
  validates  :user_name,
  presence:true,uniqueness: true
  validates :password,
  presence:true,confirmation: true
end


class Message < ActiveRecord::Base
  validates :content,
  presence:true,length:{in: 10...150}
end



class DealMassage

  def delete_at(id)
    flag=0
    message=Message.find_by(id:id)
    if message==nil
      return [0,'编号为'+id.to_s+'的留言不存在！']
    else
      flag=1
      message.destroy
      return [1,'成功删除编号为'+id.to_s+'的留言！']
    end
  end

  def delete(array)
    cnt=0
    res=Array.new
    array.each do|i|
      i=i.to_i
      flag,hint=delete_at(i)
      res.push hint
      cnt=cnt+flag
    end
    return [cnt,res]
  end

  def search_byid(id)
    message=Message.find_by(id:id)
    if (message==nil)
      return  [0,'该留言id不存在！'] # @error='该留言id不存在！';@flag=0else
    else
      return [1,message]
    end
  end

  def search_byauthor(author)
    cnt=0
    user=User.find_by(user_name:author)
    if user==nil
      return[0,'该留言者不存在！']
    else
      messages=Message.where("user_id=?",user.user_id)
      if messages==nil
        return[0,'该留言者没有发言！']
      else
        return [2,messages]
      end
    end
  end
end

5.times{|index|u=User.new;u.user_name='user'+(index+1).to_s;u.password='user'+(index+1).to_s;u.save}

10.times{|index|m=Message.new;m.content='message_content'+(index+1).to_s;m.user_id=(index+2)/2;m.create_at=Time.new;m.save}

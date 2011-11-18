class AdminMailer < ActionMailer::Base
  default from: "Llop <albertlobo1981@gmail.com>"
  default to: "albertlobo1981@gmail.com"
  
  def comment_created(comment)
    @comment = comment
    @post = comment.post
    mail subject: ("New comment on " + @post.title), sent_on: Time.now
  end
end

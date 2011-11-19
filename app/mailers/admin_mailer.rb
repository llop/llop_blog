class AdminMailer < ActionMailer::Base
  default from: "Llop <albertlobo1981@gmail.com>"
  default to: "Llop <albertlobo1981@yahoo.es>"
  
  def comment_created(comment)
    @comment = comment
    @post = comment.post
    mail subject: ("New comment on " + @post.title)
  end
  
  def something_crashed(exception)
    @exception = exception
    mail subject: ("moleculardensity crash: " + @exception.message)
  end
end

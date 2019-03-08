for ii in 1..10
  password = "password"
  @user = User.new
  @user.remember_created_at = Time.new
  @user.password = password;
  @user.email ="#{Faker::Internet.email}"
  @user.save!
  if @user.save
    p "#{@user.email} for user #{ii} has been saved"
    for ii in 1..10
      @article = Article.new
      @article.user = @user
      @article.title = "Will #{Faker::Company.name} really #{Faker::Company.bs}?"
      paragraph_1 = Faker::Lorem.paragraphs.join(' ')
      paragraph_2 = Faker::Lovecraft.paragraphs.join(' ')
      paragraph_3 = Faker::Hipster.paragraphs.join(' ')
      @article.content = "#{paragraph_1} <br /> #{paragraph_2} <br /> #{paragraph_3}"
      if @article.save
        p "#{@article.title} for article #{ii} has been saved"
        for ii in 1..10
          @comment = Comment.new
          @comment.article = @article
          @comment.user = @user
          @comment.message = Faker::Hacker.say_something_smart
          if @comment.save
            p "Comment #{ii} has been saved for article #{@article.title}"
          else
            p @comment.errors
          end
        end
      else
        p @article.errors
      end
    end
  else
    p @user.errors
  end
end
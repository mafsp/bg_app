class BlogsController < ApplicationController
  def index
    #以下は、一覧ページを作成するので、全てのブログデータをdbから取得するためのコード。
    @blogs = Blog.all
  end

  def new
    #ビューにデータを渡す（インスタンス変数を定義する）
    @blog = Blog.new
  end

  def create
    #以下は、form_withメソッドによって送られてきたデータをdbに保存するためのコード。Parameterのデータをparamsメソッドを用いて取得し、createメソッドによってdbに保存している。引数にあるblog_paramsメソッドはprivate以下で定義されている。
    #Blog.create(blog_params)
    #上記コードでもいいのだが、if文を使う場合に、validationに許されればいいが、仮にvalidationに許されなかった場合に、renderでnew画面に戻すのだが、renderの特徴として、画面の見た目を借りてくるだけなので、newメソッドにあるインスタンス変数を使用することができない。すると借りてきたnew画面にある@blogってなに？となりエラーが起きてしまう。そこで、以下のようにインスタンス変数を作成しておかなければならない。より、その過程があるのでcreateメソッドは使用できないということになる。因みにredirect＿toは一からデータを取得するのでこのような作業は不要である。
    @blog = Blog.new(blog_params)
    #validationはsaveメソッド、createメソッドやupdateメソッドなどデータを保存、更新する時に実行される。今回は以下のsaveメソッドが実行される時にvalidationが実行される。仮に、validationを通過していたら@blog.saveの返り値はtrueとなるのでif以下のコードが実行され、通過していなければ返り値はfalseとなりelse以下が実行される。
    if @blog.save
    #本来ならcreateアクションが起動したのだからcreate.html.erbという名前のviewファイルが呼び出されるのだが、以下のコードによってURLが指定されたので、index.html.erbのファイルを呼び出すことになる。
      redirect_to blogs_path, notice: "ブログを作成しました"
    else
      #以下のコードがないと、create.html.erbファイルを呼んでしまい、そのファイルは無いので結果エラーになってしまう。それを防ぐためにrenderメソッドを使用する。以下のコードはnew.html.erbファイルを呼び出している。
      render'new'
    end
  end

  def show
    #前提として、index画面からきたリクエストをどのように表示するかという話。流れは、indexからきたparameterのデータを使ってdbから欲しいデータを引っ張ってくるということ。dbにあるBlogテーブルからデータを取得するには、find(数字)メソッドを使用する。数字つまりidの取得はindex画面のリンクメソッドから送られてきparameterからparamsメソッドを用いて取得する。そのparameterはindex画面にあるblog一覧から自分が見たいデータをクリックすることによって飛んできたparameterである。
    @blog = Blog.find(params[:id])
  end

  private
  #色々な箇所で使うので一つのメソッドにした。
  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end

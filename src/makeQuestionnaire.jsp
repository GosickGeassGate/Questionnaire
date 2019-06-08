<%@ page language="java" import="java.util.*,java.io.*,java.sql.*" contentType="text/html; charset=utf-8" %>
<% request.setCharacterEncoding("utf-8"); %>
<html>
<head>
<title>Result</title>
<style type="text/css">
	*{font-size:20px;font-family:宋体}
	input[type="text"],textarea {color:#B0B0B0}
	[for="content"]{vertical-align:top;}
	fieldset {width:800px;margin:20px auto;padding:20px;background-color:#FCFCFF;}
	#content {width:700px;height:300px}
	#filename {display: none;}
</style>
</head>
<body>
<fieldset>
<%
// 连接数据库
String DBDRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver";
String DBURL="jdbc:sqlserver://127.0.0.1:1433;databaseName=questionnaire";
String DBUSER="sa";
String PASSWORD="Yunjisuan2019";

Class.forName(DBDRIVER);
Connection conn = DriverManager.getConnection(DBURL, DBUSER, PASSWORD);
//out.println("<div>连接数据库成功</div>");
Statement stmt = conn.createStatement();

// 生成提取码
Random rand = new Random();
int id = rand.nextInt(10000);	// 在0~10000中选取随机值
String sql = "select * from Manager where id = " + id;
ResultSet rs = stmt.executeQuery(sql);
while(rs.next()){
	id = rand.nextInt(10000);
	rs = stmt.executeQuery(sql);
}
String filename = "Questionnaire" + id;	// 问卷文件名，也用作数据库表名
sql = "insert into Manager values(" + id + ");";
stmt.execute(sql);

sql = "create table " + filename + "(id int IDENTITY(1,1)";
PrintWriter questOut = null;
try {
   	questOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\apache-tomcat-8.5.41\\webapps\\ROOT\\Questionnaire\\" + filename + ".txt"),"utf-8")));
} catch (Exception e) {
   	e.printStackTrace();
}

//out.print("<h1>你提交的内容如下:</h1>");
Enumeration<String> enums = request.getParameterNames();
String RadioMatrixQuestion = null;
int count = 1;	// 计数器
while(enums.hasMoreElements()){ 
	String name = (String)enums.nextElement();
	//out.println(name + ":" + request.getParameter(name) + "<br />");
	if(name.equals("title")){
		questOut.write("title\1" + request.getParameter(name) + "\r\n");
	}
	if(name.contains("RadioMatrix")){
		if(name.contains("Question")){
			RadioMatrixQuestion = request.getParameter(name);
		}
		else if(name.contains("Row")){
			sql = sql + ", Question" + (count++) + " nvarchar(50)";
			questOut.write("RadioMatrix\1" + RadioMatrixQuestion + ">>" + request.getParameter(name) + "\r\n");
		}
	}
	else if(name.contains("Question")){
		sql = sql + ", Question" + (count++) + " nvarchar(50)";
		questOut.write(name.split("_")[0] + "\1" + request.getParameter(name) + "\r\n");
	}
}
sql = sql + ");";
stmt.execute(sql);
questOut.close();

PrintWriter fout = null;
out.println("<div>预览如下所示：</div>");
try {
   	fout = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\apache-tomcat-8.5.41\\webapps\\ROOT\\Questionnaire\\" + filename + ".html"),"utf-8")));
} catch (Exception e) {
   	e.printStackTrace();
}

fout.write("<html>\r\n" +
	"<meta charset=\"utf-8\">" +
	"<head>\r\n" + 
	"<title>Questionnaire</title>\r\n" +
	"<style type=\"text/css\">\r\n" + 
	"*{font-size:20px;font-family:宋体}\r\n" +
	"input[type=\"text\"],textarea {color:#B0B0B0}\r\n" + 
	"[for=\"content\"]{vertical-align:top;}\r\n" + 
	"fieldset {width:800px;margin:20px auto;padding:20px;background-color:#FCFCFF;}\r\n" + 
	"#content {width:700px;height:300px}\r\n" +
	"#filename {display: none;}" + 
	"</style>\r\n" + 
	"</head>\r\n" +
	"<body>\r\n");
%>

<fieldset>
<%
fout.write("<fieldset>\r\n");
%>
	<%
	out.print("<legend>" + request.getParameter("title") + "</legend>");
	fout.write("<legend>" + request.getParameter("title") + "</legend>\r\n");
	%>
	<form action="http://129.211.94.198:8080/Questionnaire/analyseQuestionaire.jsp" method="post">
	<%
	fout.write("<form action=\"http://129.211.94.198:8080/Questionnaire/analyseQuestionaire.jsp\" method=\"post\">\r\n");
	out.print("<table id=\"filename\"><tr><td><input name=\"filename\" value=\"" + filename + "\"></td></tr></table>\r\n");
	fout.write("<table id=\"filename\"><tr><td><input name=\"filename\" value=\"" + filename + "\"></td></tr></table>\r\n");
	%>
		<% 
		Enumeration<String> names = request.getParameterNames();
		String type = null;     // 题目类型
		String question = null; // 问题内容
		List<String> contents = new ArrayList();  // 选项内容
		int size = 0;           // 题目数量
		int col_size = 0;       // 矩阵选择列数
		while(names.hasMoreElements()){
			String name = (String)names.nextElement();
			if(name.equals("title")){
				continue;
			}
			else{
				if(type == null){
					type = name;
					question = (String)request.getParameter(name);
				}
				else if(name.matches(type.replace("Question", "[0-9A-Za-z_]{0,}"))){
					contents.add(request.getParameter(name));
					if(name.split("_")[0].equals("RadioMatrix"))
						if(name.split("\\.")[1].substring(0, 3).equals("Col"))
							col_size++;
				}
				else{
					size++;
					out.print("<table><tr><td><b>");
					out.print(size + ". " + question);
					out.print("</b></td></tr></table>");
					fout.write("<table>\r\n<tr>\r\n<td>\r\n<b>");
					fout.write(size + ". " + question);
					fout.write("<b>\r\n</td>\r\n</tr>\r\n</table>\r\n");
					switch(type.split("_")[0]){
						case "RadioButton":
							out.print("<table>");
							fout.write("<table>\r\n");
							for(String content: contents){
								out.print("<tr><td>");
								out.print("<input name=\"RadioButton\1" + question + "\" value=\"" + content + "\" type=\"radio\" >" + content);
								out.print("</td></tr>");
								fout.write("<tr>\r\n<td>");
								fout.write("<input name=\"RadioButton\1" + question + "\" value=\"" + content + "\" type=\"radio\" >" + content);
								fout.write("</td>\r\n</tr>\r\n");
							}
							break;

						case "CheckBox":
							out.print("<table>");
							fout.write("<table>\r\n");
							for(String content: contents){
								out.print("<tr><td>");
								out.print("<input name=\"CheckBox\1" + question + "\" value=\"" + content + "\" type=\"checkbox\" >" + content);
								out.print("</td></tr>");
								fout.write("<tr>\r\n<td>");
								fout.write("<input name=\"CheckBox\1" + question + "\" value=\"" + content + "\" type=\"checkbox\" >" + content);
								fout.write("</td>\r\n</tr>\r\n");
							}
							break;
						
						case "RadioMatrix":
							out.print("<table border=\"1\"><tr><td></td>");   // 第0行第0列为空
							fout.write("<table border=\"1\">\r\n<tr>\r\n<td></td>\r\n");
							for(int i = 0; i < contents.size(); i++){
								if(i < col_size){
								out.print("<td>" + contents.get(i)+ "</td>");  // 打印列选项
								fout.write("<td>" + contents.get(i)+ "</td>\r\n");
								if(i == col_size - 1){
									out.print("</tr>");  // 换行(结束列选项填充)
									fout.write("</tr>\r\n");
								}
								}
								else{
								out.print("<tr>");
								fout.write("<tr>\r\n");
								out.print("<td>" + contents.get(i)+ "</td>");   // 打印行选项
								fout.write("<td>" + contents.get(i)+ "</td>\r\n"); 
								for(int j = 0; j < col_size; j++){
									out.print("<td><input name=\"RadioMatrix\1" + question + ">>" + contents.get(i)+ "\" value=\"" + contents.get(j) + "\" type=\"radio\" ></td>");
									fout.write("<td><input name=\"RadioMatrix\1" + question + ">>" + contents.get(i)+ "\" value=\"" + contents.get(j) + "\" type=\"radio\" ></td>\r\n");
								}
								out.print("</tr>");
								fout.write("</tr>\r\n");
								}
							}
							col_size = 0;
							break;

						case "BlankToFillIn":
							out.print("<table><tr><td><input name=\"BlankToFillIn\1" + question + "\"></td></tr>");
							fout.write("<table><tr><td><input name=\"BlankToFillIn\1" + question + "\"></td></tr>\r\n");
							break;
					}
					out.print("</table>");
					fout.write("</table>\r\n");
					type = name;
					question = (String)request.getParameter(name);
					contents.clear();
				}
			}
		}
		%>
		<table>
			<tr>
				<td>
				<input name="save" type="submit" value="保存">
				<input name="exit" type="button" value="退出" onclick="window.close();document.write('<n>')">
				<button name="reset" type="reset">复位</button>
				</td>
			</tr>
		</table>
	</form>
</fieldset>
<%
fout.write("<table>\r\n" + 
   "<tr>\r\n" + 
   "<td>\r\n" + 
   "<input name=\"save\" type=\"submit\" value=\"保存\">\r\n" +
   "<input name=\"exit\" type=\"button\" value=\"退出\" onclick=\"window.close();document.write('<n>')\">\r\n" + 
   "<button name=\"reset\" type=\"reset\">复位</button>\r\n" +
   "</td>\r\n" +
   "</tr>\r\n" +
   "</table>\r\n" +
   "</form>\r\n" +
   "</fieldset>\r\n" + 
   "</body>\r\n" +
   "</html>\r\n");
fout.close();
%>
<p>
问卷链接：
<%
out.println("<a href=\"http://129.211.94.198:8080/Questionnaire/" + filename + ".html\">");
out.println("http://129.211.94.198:8080/Questionnaire/code/" + filename + ".html</a>");
%>
</p>
<p>
<%
out.println("请务必记住问卷结果提取码：" + id);
%>
</p>
<fieldset>
   <legend>查看问卷提交结果</legend>
   <form action="http://129.211.94.198:8080/Questionnaire/getResult.jsp" method="post">
      <table id="BlankToFillIn">
         <thead>
            <tr>
               <td>
                  请输入提取码：<input name="id">
               </td>
            </tr>
         </thead>
         <tbody>
            <tr>
               <td>
                  <input name="search" type="submit" value="查找">
                  <input name="exit" type="button" value="退出" onclick="window.close();document.write('<n>')">
                  <button name="reset" type="reset">清除</button>
               </td>
            </tr>
         </tbody>
      </table>
   </form>
</fieldset>
</fieldset>
</body>


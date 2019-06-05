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
</style>
</head>
<body>
<%
String filename = "Questionnaire";	// 问卷文件名，也用作数据库表名

String DBDRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver";
String DBURL="jdbc:sqlserver://127.0.0.1:1433;databaseName=questionnaire";
String DBUSER="sa";
String PASSWORD="123456";

Class.forName(DBDRIVER);
Connection conn = DriverManager.getConnection(DBURL, DBUSER, PASSWORD);
out.println("<div>连接数据库成功</div>");
Statement state = conn.createStatement();
Statement stmt=conn.createStatement();
String sql = "create table " + filename + "(id int IDENTITY(1,1)";

PrintWriter questOut = null;
try {
   	questOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\Data\\Web\\实验\\项目\\code\\" + filename + ".txt"),"utf-8")));
} catch (Exception e) {
   	e.printStackTrace();
}

out.print("<h1>你提交的内容如下:</h1>");
Enumeration<String> enums = request.getParameterNames();
String RadioMatrixQuestion = null;
int count = 1;	// 计数器
while(enums.hasMoreElements()){ 
	String name = (String)enums.nextElement();
	out.println(name + ":" + request.getParameter(name) + "<br />");
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
   	fout = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\Data\\Web\\实验\\项目\\code\\" + filename + ".html"),"utf-8")));
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
	<form action="http://localhost:8080/实验/项目/code/analyseQuestionaire.jsp" method="post">
	<%
	fout.write("<form action=\"http://localhost:8080/实验/项目/code/analyseQuestionaire.jsp\" method=\"post\">\r\n");
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
					out.print("<table><tr><td>");
					out.print(size + ". " + question);
					out.print("</td></tr></table>");
					fout.write("<table>\r\n<tr>\r\n<td>\r\n");
					fout.write(size + ". " + question + "\r\n");
					fout.write("</td>\r\n</tr>\r\n</table>\r\n");
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
<div>
问卷链接：
<a href="http://localhost:8080/%E5%AE%9E%E9%AA%8C/%E9%A1%B9%E7%9B%AE/code/Questionnaire.html">
http://localhost:8080/%E5%AE%9E%E9%AA%8C/%E9%A1%B9%E7%9B%AE/code/Questionnaire.html
</a>
</div>
</body>
</html>
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


<%-- <fieldset>
   <legend>修改博客</legend>
   <form action="http://localhost:8080/实验/项目/code/edit.jsp" method="post">
      <table>
         <tr>
            <td>
               标题：
               <%
               out.println("<input id=\"title\" name=\"title\" value=" + request.getParameter("title") + " >");
               %>
            </td>
         </tr>
         <tr>
            <td>
               关键字：
               <%
               out.println("<input id=\"keywords\" name=\"keywords\" value=" + request.getParameter("keywords") + " >");
               %>
            </td>
         </tr>
         <tr>
            <td>
               布局：
               <%
               for(int i = 1; i <= 3; i++){
                  String layout = "layout" + i;
                  out.print("<input name=\"layout\" type=\"radio\" value=\"" + layout + "\"");
                  if(request.getParameter("layout").equals(layout)){
                     out.print(" checked");
                  }
                  out.println("><img src=\"" + layout + ".jpg\">");
               }
               %>
            </td>
         </tr>
         <tr>
            <td>
               背景：<select name="background">
                  <optgroup>
                     <%
                     for(int i = 1; i <= 4; i++){
                        out.print("<option value=\"bk" + i + "\"");
                        if(request.getParameter("background").equals("bk" + i)){
                           out.print(" checked");
                        }
                        out.println(">背景" + i + "</option>");
                     }
                     %>
                  </optgroup>
               </select>
            </td>
         </tr>
         <tr>
            <td>
               适合群体：
               <%
               String []select = request.getParameterValues("group");
               String []groups = {"学前班", "小学生", "中学生", "成年人"};
               for(int i = 1; i <= 4; i++){
                  out.print("<input name=\"group\" type=\"checkbox\" value=\"grp" + i + "\"");
                  for(int j = 0; j < select.length; j++){
                     if(select[j].equals("grp" + i)){
                        out.print(" checked");
                        break;
                     }
                  }
                  out.println(">" + groups[i - 1]);
               }
               %>
            </td>
         </tr>
         <tr>
            <td>
               内容：
               <%
               out.println("<textarea id=\"content\" name=\"content\">" + request.getParameter("content") + "</textarea>");
               %>
            </td>
         </tr>
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

<script type="text/javascript">
   function inputClick(target){
     var value="";
     if(target.id=="title")
        value="输入博客标题";
     if(target.id=="keywords")
        value="输入关键字";
     if(target.id=="content")
        value="在这里输入博客内容";

     if(target.value==''){
       target.style.color="#B0B0B0";
       target.value=value;
     }
     else 
     if(target.value==value){
        target.style.color="#000000";
        target.value="";
     }
   };
   var f1=function(){inputClick(this);};
   document.getElementById("title").onclick= f1;
   document.getElementById("keywords").onclick= f1;
   document.getElementById("content").onclick= f1;
   document.getElementById("title").onblur= f1;
   document.getElementById("keywords").onblur= f1;
   document.getElementById("content").onblur= f1;
</script> --%>

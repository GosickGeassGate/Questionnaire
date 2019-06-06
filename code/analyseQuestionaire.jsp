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
String filename = request.getParameter("filename");
String DBDRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver";
String DBURL="jdbc:sqlserver://127.0.0.1:1433;databaseName=" + filename;
String DBUSER="sa";
String PASSWORD="123456";

Class.forName(DBDRIVER);
Connection conn = DriverManager.getConnection(DBURL, DBUSER, PASSWORD);
Statement state = conn.createStatement();
Statement stmt=conn.createStatement();
out.println("<div>连接数据库成功了</div>");

out.print("<h1>你提交的内容如下:</h1>");
int counter = 1;    // 计数器
String sql = "insert into " + filename + " values";
Enumeration<String> enums = request.getParameterNames(); 
while(enums.hasMoreElements()){
    String name=(String)enums.nextElement();
    if(name.split("\1")[0].equals("CheckBox")){ // '\1'作为题目类型和题目内容的一个分隔符号
        String[] groups = request.getParameterValues(name);
        out.println(name.split("\1")[1] + ": " + Arrays.toString(groups) + "<br/>");
        sql = sql + (counter++ == 1 ? "(" : ",") + "'" + Arrays.toString(groups) + "'";
    }
    else if(name.split("\1").length > 1){
        out.println(name.split("\1")[1] + ": " + request.getParameter(name) + "<br/>");
        sql = sql + (counter++ == 1 ? "(" : ",") + "'" + request.getParameter(name) + "'";
    }
    else
        out.println(name + ": " + request.getParameter(name) + "<br/>");
}
sql = sql + ");";
out.println("<div>" + sql + "</div>");
stmt.execute(sql);

%>


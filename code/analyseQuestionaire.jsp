<%@ page language="java" import="java.util.*,java.io.*" contentType="text/html; charset=utf-8" %>
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
out.print("<h1>你提交的内容如下:</h1>");
Enumeration<String> enums = request.getParameterNames(); 
while(enums.hasMoreElements()){ 
    String name=(String)enums.nextElement();
    if(name.split("\001")[0].equals("CheckBox")){
        String[] groups = request.getParameterValues(name);
        out.println(name.split("\001")[1] + ": " + Arrays.toString(groups) + "<br/>");
    }
    else if(name.split("\001").length > 1)
        out.println(name.split("\001")[1] + ": " + request.getParameter(name) + "<br/>");
    else
        out.println(name + ": " + request.getParameter(name) + "<br/>");
}
%>
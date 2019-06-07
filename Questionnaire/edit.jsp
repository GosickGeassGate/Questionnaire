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
   if (name.equals("group")){
      String[] groups=request.getParameterValues("group");
      out.println(name+":"+Arrays.toString(groups)+"<br />"); 
   }
   else
      out.println(name+":"+request.getParameter(name)+"<br />"); 
} 

%>
<fieldset>
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
</script>
</body>
</html>
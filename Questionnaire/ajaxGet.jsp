<h1>DOM 1st Class</h1>
<p>Hello,world!</p>
<% request.setCharacterEncoding("utf-8");%>
<% 
String p5=request.getParameter("p5");
String p6=request.getParameter("p6");
out.print("Get: P5="+p5+",P6="+p6);
%>
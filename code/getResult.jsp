<%@ page language="java" import="java.util.*,java.io.*,java.sql.*" contentType="text/html; charset=utf-8" %>
<% 
request.setCharacterEncoding("utf-8");
String filename = request.getParameter("name");

Map<String, String> questionMap = new HashMap<String, String>();    // 数据库表的列名与问题内容的映射
BufferedReader reader = null;
int line = 0;
try {
   	reader = new BufferedReader(new InputStreamReader(new FileInputStream(new File("D:\\Data\\Web\\实验\\项目\\code\\" + filename + ".txt")), "utf-8"));
    String str = null;  // 缓存每一行内容
    while((str = reader.readLine()) != null){
        questionMap.put("Question" + (++line), str);
        out.println("<div>" + str + "</div>");
    }
    reader.close();
} catch (Exception e) {
   	out.println("<div>问卷不存在</div>");
}
List<ArrayList<String>> ansewerList = new ArrayList<ArrayList<String>>();    // 答案列表
for(int i = 0; i < line; i++){
    ArrayList list = new ArrayList();
    ansewerList.add(list);
}

String DBDRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver";
String DBURL="jdbc:sqlserver://127.0.0.1:1433;databaseName=questionnaire";
String DBUSER="sa";
String PASSWORD="123456";

Class.forName(DBDRIVER);
Connection conn = DriverManager.getConnection(DBURL, DBUSER, PASSWORD);
out.println("<div>连接数据库成功</div>");
Statement stmt = conn.createStatement();    // 创建MySQL语句的对象
ResultSet rs = stmt.executeQuery("select * from " + filename);  //执行查询，返回结果集
while(rs.next()){
    for(int i = 1; i <= line; i++){
        ansewerList.get(i - 1).add(rs.getString("Question" + i));
    }
}
for(int i = 1; i <= line; i++){
    out.println("<p>" + questionMap.get("Question" + i) + "<br/>");
    for(String answer: ansewerList.get(i - 1)){
        out.println(answer + "<br/>");
    }
    out.println("</p>");
}
%>

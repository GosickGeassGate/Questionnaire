<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*" contentType="text/html; charset=utf-8" %>
<html>
<head>
<title>Result</title>
<style type="text/css">
	*{font-size:20px;font-family:宋体}
	input[type="text"],textarea {color:#B0B0B0}
	[for="content"]{vertical-align:top;}
	fieldset {width:800px;margin:20px auto;padding:20px;background-color:#FCFCFF;}
</style>
<% 
request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
String filename = "Questionnaire" + id;

Map<String, String> questionMap = new HashMap<String, String>();    // 数据库表的列名与问题内容的映射
String title = "";
BufferedReader reader = null;
int line = 0;
try {
   	reader = new BufferedReader(new InputStreamReader(new FileInputStream(new File("D:\\Data\\Web\\实验\\项目\\code\\" + filename + ".txt")), "utf-8"));
    String str = null;  // 缓存每一行内容
    while((str = reader.readLine()) != null){
        if(str.split("\1")[0].equals("title")){
            title = str.split("\1")[1];
        }
        else{
            questionMap.put("Question" + (++line), str);
        }
        //out.println("<div>" + str + "</div>");
    }
    reader.close();
} catch (Exception e) {
   	//out.println("<div>问卷不存在</div>");
    out.println("<script>alert(\"问卷不存在\");</script>");
    return;
}
List<ArrayList<String>> answerList = new ArrayList<ArrayList<String>>();    // 答案列表
List<HashMap<String, Integer>> answerCount = new ArrayList<HashMap<String, Integer>>();  // 答案统计
for(int i = 0; i < line; i++){
    ArrayList<String> list = new ArrayList<String>();
    answerList.add(list);
    HashMap<String, Integer> map = new HashMap<String, Integer>();
    answerCount.add(map);
}

String DBDRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver";
String DBURL="jdbc:sqlserver://127.0.0.1:1433;databaseName=questionnaire";
String DBUSER="sa";
String PASSWORD="123456";

Class.forName(DBDRIVER);
Connection conn = DriverManager.getConnection(DBURL, DBUSER, PASSWORD);
//out.println("<div>连接数据库成功</div>");
Statement stmt = conn.createStatement();    // 创建MySQL语句的对象
ResultSet rs = stmt.executeQuery("select * from " + filename);  //执行查询，返回结果集
while(rs.next()){
    for(int i = 1; i <= line; i++){
        String answer = rs.getString("Question" + i);
        answerList.get(i - 1).add(answer);

        if(questionMap.get("Question" + i).split("\1")[0].equals("CheckBox")){
            String[] answers = answer.substring(1, answer.length() - 1).split(","); // 去掉方括号再根据逗号分隔
            for(int j = 0; j < answers.length; j++){
                if(answerCount.get(i - 1).keySet().contains(answers[j])){
                    answerCount.get(i - 1).put(answers[j], answerCount.get(i - 1).get(answers[j]) + 1);
                }
                else{
                    answerCount.get(i - 1).put(answers[j], 1);
                }
            }
        }
        else{
            if(answerCount.get(i - 1).keySet().contains(answer)){
                answerCount.get(i - 1).put(answer, answerCount.get(i - 1).get(answer) + 1);
            }
            else{
                answerCount.get(i - 1).put(answer, 1);
            }
        }
    }
}

out.println("</head><body><fieldset><legend>" + title + "</legend>");
int size = answerList.get(0).size();
NumberFormat format = NumberFormat.getPercentInstance();
format.setMaximumFractionDigits(2); //设置保留2位小数
for(int i = 1; i <= line; i++){
    out.print("<p>" + i + ". " + questionMap.get("Question" + i).split("\1")[1]);
    switch(questionMap.get("Question" + i).split("\1")[0]){
        case "RadioButton":
            out.println("（单选）" + "<br/>");
            break;
        case "CheckBox":
            out.println("（多选）" + "<br/>");
            break;
        case "RadioMatrix":
            out.println("（矩阵选择）" + "<br/>");
            break;
        case "BlankToFillIn":
            out.println("（填空）" + "<br/>");
    }
    for(String answer: answerCount.get(i - 1).keySet()){
        out.println(answer + ": " + format.format((double)(answerCount.get(i - 1).get(answer)) / size) + "<br/>");
    }
    for(String answer: answerList.get(i - 1)){
        out.println(answer + "<br/>");
    }
    out.println("</p>");
}

PrintWriter writer = null;
try {
   	writer = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\Data\\Web\\实验\\项目\\code\\" + filename + ".csv"),"gbk")));
    for(int i = 1; i <= line; i++){
        writer.write(questionMap.get("Question" + i).split("\1")[1] + (i == line ? "\r\n" : ","));
    }
    for(int i = 0; i < size; i++){
        for(int j = 1; j <= line; j++){
            writer.write(answerList.get(j - 1).get(i).replaceAll(",", "，") + (j == line ? "\r\n" : ","));
        }
    }
} catch (Exception e) {
   	e.printStackTrace();
}
writer.close();

out.print("<p>获取具体答案表格：<a href=\"http://localhost:8080/%E5%AE%9E%E9%AA%8C/%E9%A1%B9%E7%9B%AE/code/" + filename + ".csv\">" +
    "http://localhost:8080/%E5%AE%9E%E9%AA%8C/%E9%A1%B9%E7%9B%AE/code/" + filename + ".csv</a></p>");
%>
</fieldset>
</body>
</html>
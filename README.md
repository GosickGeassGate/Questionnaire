* 动态html
  * 可以从最底端点击按键增加题目
  * 显示加减图标按键，悬停可以更换图片（灰->红）
  * 可以删除当前题目或选项（-）
  * 可以在下方增加相同类型的题目或选项（+）
  * 可以将题目或选项上移或下移
  * 可以生成问卷
  * 提交问卷可以提取填写内容
* jsp生成预览以及写入html文件，并显示html链接
* 能够连接本地SQL Server数据库，在生成问卷的同时创建表，在提交问卷的同时向表插入数据
* 使用txt文件保存问题内容和数据库表的列名之间的一一映射
* 可以获取问卷提交的结果（统计概率以及生成表格）
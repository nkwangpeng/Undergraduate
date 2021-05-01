package student;

import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
class FindPanel extends JPanel{  
    public void paintComponent(Graphics g){  
        super.paintComponent(g);  
        //绘制一张背景图片  2.jpg是图片的路径  自己设定为自己想要添加的图片  
        Image image = new ImageIcon("images//back.png").getImage();  
        g.drawImage(image, 0, 0, this);  
    }

	public void dispose() {
		// TODO Auto-generated method stub
		this.dispose();
	}  
}

public class find extends JFrame {
	DefaultTableModel model=null;
	FindPanel panel=new FindPanel();
	JLabel label = new JLabel("输入待查询成绩的学号");
	JTextField textId = new JTextField();
	JButton buttonFind = new JButton("查询");
	JButton buttonReturn = new JButton("返回");

	Vector rowData, columnNames;
	JTable table = null;
	JScrollPane scrollpane = null;
	PreparedStatement prestatement = null;
	Connection conn = null;
	ResultSet result = null;

	public find() {
		setTitle("查询学生成绩");
		label.setBounds(new Rectangle(530, 210, 200, 40));
		textId.setBounds(new Rectangle(530, 260, 200, 35));
		

		label.setForeground(Color.white);
		label.setFont(new java.awt.Font("宋体", Font.BOLD, 20));
		
		buttonFind.setBounds(new Rectangle(530, 325, 60, 30));
		buttonReturn.setBounds(new Rectangle(650, 325, 60, 30));

		buttonFind.addActionListener(new findLisener());
		buttonReturn.addActionListener(new returnLisener());

		columnNames = new Vector();
		columnNames.add("学号");
		columnNames.add("课程");
		columnNames.add("成绩");

		rowData = new Vector(); // rowData可以存放多行,开始从数据库里取
		try {
			// 加载驱动
			Class.forName("com.mysql.cj.jdbc.Driver");
			// 得到连接
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student?useSSL=false&serverTimezone=UTC", "root",
					"wp010214");
			prestatement = conn.prepareStatement("select * from score ");
			result = prestatement.executeQuery();

			while (result.next()) {
				// rowData可以存放多行
				Vector row = new Vector();
				row.add(result.getInt(1));
				row.add(result.getString(2));
				row.add(result.getInt(3));

				// 加入到rowData
				rowData.add(row);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 初始化Jtable
		model = new DefaultTableModel(rowData,columnNames);
		table = new JTable(model);
		table();
	}

	void table() {
		scrollpane = new JScrollPane(table);
		scrollpane.setBounds(new Rectangle(30, 210,400, 200));
		panel.setLayout(null);
		panel.add(label);
		panel.add(textId);
		panel.add(buttonFind);
		panel.add(buttonReturn);
		panel.add(scrollpane);
		this.add(panel);

		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(800, 700);
		setLocationRelativeTo(null);
		this.setResizable(false);
		setVisible(true);
	}

	class findLisener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			Vector newrowData = new Vector();
			String s = textId.getText();
			int id = Integer.parseInt(s);
			try {
				Statement statement = conn.createStatement();
				String sql = "select * from scoreview where id=" + id;
				ResultSet rs = statement.executeQuery(sql);
				while (rs.next()) {
					Vector newrow = new Vector();
					newrow.add(rs.getInt(1));
					newrow.add(rs.getString(2));
					newrow.add(rs.getInt(3));
					// 加入到rowData
					newrowData.add(newrow);
				}
				if (!newrowData.isEmpty()) {
					JOptionPane.showMessageDialog(null, "查询成功", "成功", JOptionPane.INFORMATION_MESSAGE);
				} else {
					JOptionPane.showMessageDialog(null, "查询失败", "失败", JOptionPane.INFORMATION_MESSAGE);
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			model=new DefaultTableModel(newrowData,columnNames);
			table.setModel(model);
			panel.repaint();

		}
	}

	class returnLisener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			dispose();
			new mainwin();
		}
	}

	public static void main(String args[]) {
		new find();
	}
}



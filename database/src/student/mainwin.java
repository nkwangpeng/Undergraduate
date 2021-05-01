package student;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
class MainPanel extends JPanel{  
    public void paintComponent(Graphics g){  
        super.paintComponent(g);  
        //绘制一张背景图片  2.jpg是图片的路径  自己设定为自己想要添加的图片  
        Image image = new ImageIcon("images//back.png").getImage();  
        g.drawImage(image, 0, 0, this);  
    }  
}
public class mainwin extends JFrame {
	MainPanel panel=new MainPanel();
	JButton B1=new JButton("插入学生信息");
	JButton B2=new JButton("删除学生信息");
	JButton B3=new JButton("更新学生信息");
	JButton B4=new JButton("按学号查询学生成绩");
	JButton B5=new JButton("按课程查询学生成绩");
	public mainwin(){
		setTitle("功能选择");

		B1.setBounds(new Rectangle(120,40,170,30));
		B2.setBounds(new Rectangle(120,100,170,30));
		B3.setBounds(new Rectangle(120,160,170,30));
		B4.setBounds(new Rectangle(120,220,170,30));
		B5.setBounds(new Rectangle(120,280,170,30));
		B1.addActionListener(new insertListener());
		B2.addActionListener(new deleteListener());
		B3.addActionListener(new updateListener());
		B4.addActionListener(new findListener());
		B5.addActionListener(new queryListener());
		/*Container contpane=getContentPane();
		contpane.setLayout(null);
		contpane.add(B1);
		contpane.add(B2);
		contpane.add(B3);
		contpane.add(B4);*/
		panel.setLayout(null);
		panel.add(B1);
		panel.add(B2);
		panel.add(B3);
		panel.add(B4);
		panel.add(B5);
		this.add(panel);
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(420, 420);
		setLocationRelativeTo(null);
		setVisible(true);
		this.setResizable(false);
		
	}
	class insertListener implements ActionListener{
		public void actionPerformed(ActionEvent e) {
			dispose();
			new insert();
		}	
	}
	
	class deleteListener implements ActionListener{
		public void actionPerformed(ActionEvent e) {
			dispose();
			new delete();
		}	
	}
	class updateListener implements ActionListener{
			public void actionPerformed(ActionEvent e) {
				dispose();
				new update();
			}	
		}
	class findListener implements ActionListener{
			public void actionPerformed(ActionEvent e) {
				dispose();
				new find();
			}	
		}
	class queryListener implements ActionListener{
		public void actionPerformed(ActionEvent e) {
			dispose();
			new query();
		}	
	}
	public static void main(String args[]){
		new mainwin();
	}
	}

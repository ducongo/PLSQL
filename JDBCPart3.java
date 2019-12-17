/*This is a sample JDBC program. In order to run it,
   You need to do the following. 

1. edit this file with correct oracle username and password
2. javac JDBCselect.java
3. java JDBCselect


If you don't have this table in your database, you will
get error message displayed. 
*/

import java.sql.*;
import java.io.*;
import oracle.jdbc.*;
import oracle.sql.*;
import java.util.*;

import java.util.Scanner;

public class JDBCPart3{

    static Connection conn = null;
    static Scanner input = new Scanner(System.in);

    public static void main(String[] args) {

        try{

            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            
            System.out.println("Connecting to JDBC...");

            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","fedora","oracle");
                //param1: the JDBC URL
                //param2: the name you used to log in to the DBMS
                //param3: the password

            System.out.println("JDBC connected.\n");

            // Statement stmt = conn.createStatement();
            // stmt.executeUpdate("INSERT INTO closedbranch values('619', '3-1565 Heron road')");

            menu();

            
            
            
        }
        catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }
    }

    public static void displayMenu(){
        System.out.println("Please select one of the options.");
        System.out.println("1. Get branch\n");
        System.out.println("2. Open a branch\n");
        System.out.println("3. Close a branch\n");
        System.out.println("4. Create a customer\n");
        System.out.println("5. Remove a customer\n");
        System.out.println("6. Open an account\n");
        System.out.println("7. Close an account\n");
        System.out.println("8. Withdraw\n");
        System.out.println("9. Deposit\n");
        System.out.println("10. Transfer\n");
        System.out.println("11. Show branch\n");
        System.out.println("12. Show all branches\n");
        System.out.println("13. Show customer\n");
        System.out.println("0. To exit the program\n");
        
    }


    public static void menu(){
        
        displayMenu();
        String consumeNewLine;
        int option = -1;

        loop: while (true){
            try{
                if (option != 0){
                    option = input.nextInt();
                    consumeNewLine = input.nextLine();
                }

                switch(option) {
                    case 0:
                        System.out.println("Exiting program...");
                        break loop;
                    case 1:
                        System.out.print("Please enter the branch address: ");
                        try{
                            
                            String address = input.nextLine();
                            branch(address);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 2:
                        System.out.print("Please enter the branch address: ");
                        try{
                            
                            String address = input.nextLine();
                            open_branch(address);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 3:
                        System.out.print("Please enter the branch address: ");
                        try{
                            
                            String address = input.nextLine();
                            close_branch(address);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 4:
                        System.out.print("Please enter the customer's name: ");
                        try{
                            
                            String name = input.nextLine();
                            create_customer(name);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 5:
                        System.out.print("Please enter the customer's name: ");
                        try{
                            
                            String name = input.nextLine();
                            remove_customer(name);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 6:
                        
                        try{

                            String customer;
                            String address;
                            Double amount;

                            System.out.println("Please enter the customer's name or number: ");
                            customer = input.nextLine();

                            System.out.println("Please enter the branch address: ");
                            address = input.nextLine();

                            System.out.println("Please enter the ammount: ");
                            amount = input.nextDouble();

                            open_account(customer, address, amount);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 7:
                        System.out.println("Please enter the account number: ");
                        try{
                            
                            String account_number = input.nextLine();
                            close_account(account_number);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 8:
                        
                        try{
                            String account_number;
                            Double amount;

                            System.out.println("Please enter the account number: ");
                            account_number = input.nextLine();

                            System.out.println("Please enter the ammount: ");
                            amount = input.nextDouble();

                            withdraw(account_number, amount);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 9:
                        
                        try{
                            String account_number;
                            Double amount;

                            System.out.println("Please enter the account number: ");
                            account_number = input.nextLine();

                            System.out.println("Please enter the ammount: ");
                            amount = input.nextDouble();

                            deposit(account_number, amount);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        
                        break;
                    case 10:
                        
                        try{
                            String account_number1;
                            String account_number2;
                            Double amount;

                            System.out.println("Please enter the account number to withdraw from: ");
                            account_number1 = input.nextLine();

                            System.out.println("Please enter the account number to deposit to: ");
                            account_number2 = input.nextLine();

                            System.out.println("Please enter the ammount: ");
                            amount = input.nextDouble();
                            

                            transfer(account_number1, account_number2, amount);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 11:
                        System.out.print("Please enter the branch address: ");
                        try{
                            
                            String address = input.nextLine();
                            show_branch(address);

                        }catch(Exception e){
                            System.out.println("Error with input value(s)");
                        }
                        break;
                    case 12:
                        show_all_branches();
                        break;
 
                    default:
                        System.out.println("Please select a valid option listed above");
                    // code block
                }  
                System.out.println("");
                displayMenu();

            }catch(InputMismatchException e){
                System.out.println("Please enter a valid number");
                consumeNewLine = input.nextLine();
            }
            
        }
    }


    public static String branch(String address){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{? = call bank.get_branch(?)}");
            
            cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
            cstmt.setString(2, address);
            cstmt.execute();

            String branch_number = cstmt.getString(1);
            
            System.out.println("Branch number: " + branch_number);

            return branch_number;
                        
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }

      return null;
    }

    public static String open_branch(String address){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{? = call bank.open_branch(?)}");
            
            cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
            cstmt.setString(2, address);
            cstmt.execute();

            String branch_number = cstmt.getString(1);
            
            System.out.println("Branch number: " + branch_number);

            return branch_number;
                        
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      return null;
    }

    public static void close_branch(String address){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.close_branch(?)}");
        
            cstmt.setString(1, address);
            cstmt.execute();
            
            System.out.println("Branch closed");

                        
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void create_customer(String name){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.create_customer(?)}");
        
            cstmt.setString(1, name);
            cstmt.execute();
            
            System.out.println("Customer created");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void remove_customer(String name){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.remove_customer(?)}");
        
            cstmt.setString(1, name);
            cstmt.execute();
            
            System.out.println("Customer removed");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void open_account(String customer, String address, double amount){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.open_account(?,?,?)}");
        
            cstmt.setString(1, customer);
            cstmt.setString(2, address);
            cstmt.setDouble(3, amount);
            cstmt.execute();
            
            System.out.println("Account opened");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }finally{
            try{
                if (cstmt != null){
                    cstmt.close();
                }

                if (conn != null){
                    conn.commit();
                    conn.setAutoCommit(true);
                }

            }catch(Exception e){
                System.out.println("SQL exception: ");
                e.printStackTrace();
                
            }
        }
      
    }

    public static void close_account(String account_number){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.close_account(?)}");
        
            cstmt.setString(1, account_number);
            cstmt.execute();
            
            System.out.println("Account closed");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void withdraw(String account_number, double amount){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.withdraw(?,?)}");
        
            cstmt.setString(1, account_number);
            cstmt.setDouble(2, amount);
            cstmt.execute();
            
            System.out.println("Money withdrawned");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void deposit(String account_number, double amount){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.deposit(?,?)}");
        
            cstmt.setString(1, account_number);
            cstmt.setDouble(2, amount);
            cstmt.execute();
            
            System.out.println("Money Deposited");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void transfer(String account_number1, String account_number2, double amount){
        CallableStatement cstmt = null;
        try{
            conn.setAutoCommit(false);
            cstmt = conn.prepareCall("{call bank.transfer(?,?,?)}");
        
            cstmt.setString(1, account_number1);
            cstmt.setString(2, account_number2);
            cstmt.setDouble(3, amount);
            cstmt.execute();
            
            System.out.println("Money transferred");
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (cstmt != null){
                cstmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void show_branch(String address){
        Statement stmt = null;
        try{
            conn.setAutoCommit(false);
            stmt = conn.createStatement();
            ResultSet rs;

            rs = stmt.executeQuery("select account_number, account_balance, branch_total, branch_number from table(bank.show_branch('"+ address +"'))");

            System.out.println("account_number     account_balance     branch_number     branch_total");
            while(rs.next()){
                String anum = rs.getString("account_number");
                double balance = rs.getDouble("account_balance");
                double total = rs.getDouble("branch_total");
                String bnum = rs.getString("branch_number");
                System.out.println(anum + "            " + balance + "             " + bnum + "               " + total);
            }
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (stmt != null){
                stmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    public static void show_all_branches(){
        Statement stmt = null;
        try{
            conn.setAutoCommit(false);
            stmt = conn.createStatement();
            ResultSet rs;

            rs = stmt.executeQuery("select account_number, account_balance, branch_total, branch_number from table(bank.show_all_branches)");

            System.out.println("account_number     account_balance     branch_number     branch_total");
            while(rs.next()){
                String anum = rs.getString("account_number");
                double balance = rs.getDouble("account_balance");
                double total = rs.getDouble("branch_total");
                String bnum = rs.getString("branch_number");
                System.out.println(anum + "            " + balance + "             " + bnum + "               " + total);
            }
  
        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	  }finally{
        try{
            if (stmt != null){
                stmt.close();
            }

            if (conn != null){
                conn.commit();
                conn.setAutoCommit(true);
            }

        }catch(Exception e){
            System.out.println("SQL exception: ");
            e.printStackTrace();
            
	    }
      }
      
    }

    // public static void setup_account(String customerName, String identifier, boolean setupByBnum, double balance){
        
    // }

    // public static void close_account(String customerName, String identifier, boolean closeByBnum){

           
    // }

    // public static double withdraw(String customerName, String anum, double amount){
        
    // }

    // public static double deposit(String customerName, String anum, double amount){
        
    // }

    // public static void transfer(String customerName, String anum1, String anum2, double amount){
        
    // }

    // public static void setup_customer(String customerName, String identifier, boolean setupByBnum){
        
    // }

    // public static void show_all_branches(){
        
    // }

    // public static void show_branch(String identifier, boolean getByBnum, boolean showAllBranch){
        
    // }

    // public static String get_account_number(Statement stmt, String bnum){
        
        
    // }

    

    // public static String get_customer_number(Statement stmt){
        
        
    // }

}
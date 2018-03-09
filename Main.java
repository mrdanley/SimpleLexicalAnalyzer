import java.io.*;

public class Main
{
    public static void main(String[] args)
    {
        try
        {
            System.out.println("Parsing ");
            Lexer lexer = new Lexer(new FileReader(new File(args[0])));
            parser p = new parser(lexer);
            p.parse();
            System.out.println("No errors.");
        }
        catch (Exception e) {
            try (BufferedWriter buffWriter = new BufferedWriter(new FileWriter("outputFile.txt",true))) {
                buffWriter.write("Not working");
                buffWriter.close();
            } catch (IOException ex) {
                e.printStackTrace();
            }
        }
    }

}

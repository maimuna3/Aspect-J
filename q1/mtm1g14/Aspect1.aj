package q1.mtm1g14;

import java.io.*;

// create aspect Aspect1
public aspect Aspect1 {
	
	//declares file writer
	private FileWriter fileWriter;
	
	//declares buffered writer
	private BufferedWriter bufferedWriter;
	
	
	/* declares a pointcut nodesPointcut that
	 *matches method calls made to public methods that take one argument int 
	 *and returns an int and are defined in any class with the package q1*/
	pointcut nodesPointcut():
		call(public int q1..*(int));

	// declares a pointcut deleteMain 
	pointcut deleteMain():
		execution(public * q1..*.main(..));
	
	/* pointcut that deletes any existing csv files when main starts executing
	 * to avoid writing(updating) to an existing csv file*/
	before(): deleteMain()
	{
		File csv = new File("q1-nodes.csv");
		File csv2 = new File("q1-edges.csv");
		if(csv.exists())
		{
			csv.delete();
		}
		if(csv2.exists())
		{
			csv2.delete();
		}
		else return;
	}

	/*pointcut that gets the signature name of the method it catches, extracts the method name 
	 * and write the nodes to a file*/
	before(): nodesPointcut()
	{
		
		String s = thisJoinPointStaticPart.getSignature().toString();
		String nodes = s.substring(s.lastIndexOf('.')-1);
		
		//create a new file q1-nodes.csv and writes the nodes to the file
		try {
			
				fileWriter = new FileWriter("q1-nodes.csv", true);
				bufferedWriter = new BufferedWriter(fileWriter);
				bufferedWriter.write(nodes + "\n");
				bufferedWriter.flush();
				bufferedWriter.close();
				fileWriter.close();
			
			}
		
			catch(IOException e)
			{
		
				throw new RuntimeException("Cannot open 'q1-nodes.csv' for writing.", e);
			}
	}
	
	/*pointcut that gets the signature names  of the methods it catches, 
	 * extracts the method name 
	 * and write the nodes as edges to a file*/
	before(): nodesPointcut() && withincode(public int q1..*(int))
	
	{	// gets the signature name of the method that is being called  
		String s = thisJoinPointStaticPart.getSignature().toString();
		
		//gets the signature name of the method that called the current method
		String t = thisEnclosingJoinPointStaticPart.getSignature().toString();
		
		//extracts only the method names from the signature names
		String nodes = s.substring(s.lastIndexOf('.')-1);
		String nodes2 = t.substring(t.lastIndexOf('.')-1);
		
		try {// creates new file q1-edges.csv and writes the edges to the file
			
				fileWriter = new FileWriter("q1-edges.csv", true);
				bufferedWriter = new BufferedWriter(fileWriter);
				bufferedWriter.write(nodes2+ " -> " + nodes + "\n");
				bufferedWriter.flush();
				bufferedWriter.close();
				fileWriter.close();
			} 
		
		catch(IOException e)
		{
			throw new RuntimeException("Cannot open 'q1-edges.csv' for writing.", e);
		}
		
	}
	
}
	
	 


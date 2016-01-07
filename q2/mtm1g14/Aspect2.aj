package q2.mtm1g14;

import java.io.*;

//creates new aspect
public aspect Aspect2 {
	
	    //declares file writer
		private FileWriter fileWriter;
		
		//declares buffered writer
		private BufferedWriter bufferedWriter;
		
		/* declares a pointcut edgesPointcut that
		 *matches method calls made to public methods that take one argument int 
		 *and returns an int and are defined in any class with the package q2*/
		pointcut edgesPointcut():
		call(public int q2..*(int));
		
		// declares a pointcut deleteMain 
		pointcut deleteMain():
		execution(public * q2..*.main(..));
	

		/* pointcut that deletes any existing csv files when main starts executing
		 * to avoid writing(updating) to an existing csv file*/
		before(): deleteMain()
		{
			File csv = new File("q2-nodes.csv");
			File csv2 = new File("q2-edges.csv");
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
		  and write the nodes to a file*/
		int around() throws Exception: edgesPointcut() && withincode(public int q2..*(int) throws Exception)
		{
			String nodes="";
			String nodes2="";
			
			try{
					// gets the signature name of the method that is being called  
					String s = thisJoinPointStaticPart.getSignature().toString();
					
					//gets the signature name of the method that called the current method
					String t = thisEnclosingJoinPointStaticPart.getSignature().toString();
					
					//extracts only the method names from the signature names
					nodes = s.substring(s.lastIndexOf('.')-1);
					nodes2 = t.substring(t.lastIndexOf('.')-1);
		
					//create a new file q2-egdes.csv and writes the nodes to the file
					fileWriter = new FileWriter("q2-edges.csv", true);
					bufferedWriter = new BufferedWriter(fileWriter);
					bufferedWriter.write(nodes2+ " -> " + nodes + "\n");
					bufferedWriter.flush();
					bufferedWriter.close();
					fileWriter.close();
					
					/*continues invoking methods after throwing an exception. The methods 
					 that are invoked are not within the definition of the node that throws the exception */
					proceed();
			} 
			catch(Exception e)
			{
			
			}
			return 0;
	 		
		}
	}

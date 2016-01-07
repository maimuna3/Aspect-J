package q3.mtm1g14;

import java.io.*;

import java.util.*;

//creates new aspect
public aspect Aspect3 {
	
	/* declares a pointcut edgesPointcut that
	 *matches method calls made to public methods that take one argument int 
	 *and returns an int and are defined in any class with the package q3*/
		pointcut value():
		call(public int q3..*(int));
		
		pointcut failure():
			call(public int q3..*(int) throws Exception);
	
	//creates a hashmap to store values of input and return parameters and their frequency of occurrence
	private HashMap<Integer, Integer> inputValue = new HashMap<>();
	private HashMap<Integer, Integer> returnValue = new HashMap<>();
	
	/*checks if a file exist and delete it if it does then creates a new file that 
	 * appends the input value of a method and its frequency of occurrence for each method */
	public int histFile(String name, HashMap<Integer, Integer> mi, HashMap<Integer, Integer> mj)
	{
		//checks if file exist
		File myFile = new File(name+"-hist.csv");
		if(myFile.exists()) {
			myFile.delete();
		}
			try{//creates file 
				FileWriter fw = new FileWriter(name+"-hist.csv", true);
				
				// appends input parameter and its frequency of occurrence
				fw.append("Input Value, Value Frequency\n");
				
				/*maps values and its occurrence frequency and 
				appends input parameter and its frequency of occurrence*/
				for(Map.Entry<Integer, Integer> entry: mi.entrySet())
				{
					fw.append(entry.getKey() + "," + entry.getValue() + "\n");
					
				}
				
				//appends output values and its frequency of occurrence
				fw.append("Output Value, Value Frequency\n");
						
				//maps values and its occurrence frequency
				for(Map.Entry<Integer, Integer> entry: mj.entrySet())
				{
					fw.append(entry.getKey() + "," + entry.getValue() + "\n");
							
				}
				
				fw.flush();
				fw.close();
			}
			catch(Exception e){}
		return 0;
	}
	
	/*pointcut that gets the signature name of the method it catches, extracts the method name 
	  and write the nodes to a file*/
	int around(int i): value() && args(i)
	{	
		// gets the signature name of the method that is being called  
		String s = thisJoinPointStaticPart.getSignature().toString();
		
		//gets the signature name of the method that called the current method
		String names = s.substring(s.lastIndexOf('.')+1, s.indexOf("("));
		
		//check if input parameter exist for each method. if it does, increment its frequency
		if(inputValue.containsKey(i)){
			inputValue.put(i, inputValue.get(i)+1);
		}
		//if the input parameter does not exist, add 1 to its frequency.
		else
		{
			inputValue.put(i, 1);
		}
		int j= 0;
		j = proceed(i);
		//check if return parameter exist for each method. if it does, increment its frequency
		if(returnValue.containsKey(j))
		{
			returnValue.put(j, returnValue.get(j)+1);
		}
		//if the return parameter does not exist, add 1 to its frequency.
		else
		{
			returnValue.put(j, 1);
		}
		return histFile(names, inputValue, returnValue);
	}
	
	/*initialize the variables that store the number of all method calls as well as the calls that
	  that failed due to exceptions*/
	int allCalls = 0;
	int failedCalls = 0;
	
	
	/*checks if a file exist and delete it if it does then creates a new file that 
	 * appends the total number of calls made to methods and the number of calls that failed due 
	 * to exceptions */
	 public int failureFile(int total, int failed, double percentageFailure)
	 {
		 //checks if it exists, if it does, it deletes it to avoid updating an existing file
		 File myFile = new File("Failures.csv");
			if(myFile.exists()) {
				myFile.delete();
			}
				try{
					//creates file  
					FileWriter fw = new FileWriter("failures.csv", true);
					//appends column headings
					fw.append("Total Calls Made, Total Calls Failed, Percentage Failed\n");
					//appends values of method calls and failed method calls
					fw.append(total + "," + failed + "," + String.format("%d", (long)percentageFailure) + "%\n");
		 			fw.flush();
					fw.close();
				  }
					catch(Exception e){}

		 			return 0;
	 				}
	 
	 /*pointcut that gets the signature name of the method it catches, extracts the method name 
	  and write the nodes to a file*/
	 int around(int i) throws Exception: failure() && args(i)

	 {
		 //check if input parameter exist for each method. if it does, increment its frequency
		 if(inputValue.containsKey(i))
		 	{
				inputValue.put(i, inputValue.get(i)+1);
			}
			//if the input parameter does not exist, add 1 to its frequency.
			else
			{
				inputValue.put(i, 1);
			}
		 
		  	int j = 0;
		  	try{
		  		allCalls++;
		  		j = proceed(i);
		  	}
		  	catch(Exception e)
		  	{
		  		failedCalls++;
		  	}
		  	
		  //check if return parameter exist for each method. if it does, increment its frequency
		  if(returnValue.containsKey(j))
		  {
			returnValue.put(j, inputValue.get(j)+1);
		  }
			//if the return parameter does not exist, add 1 to its frequency.
		  else
		  {
			returnValue.put(j, 1);
		  }
		  double percentageFailure = (failedCalls/allCalls)*100;
		
		return failureFile(allCalls, failedCalls, percentageFailure);
			
	 }
	 
}




	  
	  

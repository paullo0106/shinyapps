library(shiny)

POUNDS_TO_KG <<- 2.204  # 1 kg = 2.204 pounds
INCHES_TO_M <<- 0.0254 # 1 inches = 0.254 m

# calculate BMI based on fomula, w is in kg, and h is in m

calculateBMI <- function(w,h) w/(h*h)  

calculate <- function(w_type,h_type,h1,h2,h,w,w2){ 
   new_w <<- w
   new_h <<- h
   if(w_type=='pounds'){ #convert the value to kg-based
      new_w <<- w2/POUNDS_TO_KG 
   }
   
   if(h_type=='f'){ #convert the value to m-based
        new_h <<- (h1*12+h2)*INCHES_TO_M
   }
   calculateBMI(new_w,new_h)

}

shinyServer(
  function(input, output){

    #output$bmi <-renderText({calculate(input$weight_unit,input$height_unit,as.numeric(input$height_feet),as.numeric(input$height_inch),input$height,input$weight,input$weight2)}) 
    
    bmiVal <- reactive({calculate(input$weight_unit,input$height_unit,as.numeric(input$height_feet),as.numeric(input$height_inch),input$height,input$weight,input$weight2)}) 
    output$bmi <- renderText({bmiVal()})
    
    # check BMI categories according to calculation result
    observe({
      bmi <- bmiVal()
      
      if(bmi>=30)
        output$result <- renderText('Obesity')
      else if(bmi>=25)
        output$result <- renderText('Overweight')
      else if(bmi>=18.5)
        output$result <- renderText('Normal weight')
      else
        output$result <- renderText('Underweight')
      
      # calculate and draw three lines to notify user the BMI categories they would become after weight loss/gain 
      h <- input$height
      if(input$height_unit=='f')
         h <- (as.numeric(input$height_feet)*12+as.numeric(input$height_inch))*INCHES_TO_M
      
      ob = 30*h^2 # line for obesity/overweight
      ov = 25*h^2 # line for overweight/normal weight
      no = 18.5*h^2 # line for normal weight/underweight
      w <- input$weight
      if(input$weight_unit=='pounds'){ # need to adjust to kg-pounds conversion
        w <- input$weight2
        weight_range <- 0:w*2
        bmi <- weight_range/POUNDS_TO_KG/h^2    
        x_label = "Weight (pounds)"

        ob = ob*POUNDS_TO_KG
        ov = ov*POUNDS_TO_KG
        no = no*POUNDS_TO_KG
      }
      else{
        weight_range <- 0:w*2
        bmi <- weight_range/h^2
        x_label = "Weight (kg)"
      }
      ob = round(ob,2)
      ov = round(ov,2)
      no = round(no,2)  
      
      lower_bound = 0-w  # negative to ensure it occupy the downmost part
      upper_bound = 400 # big enough to ensure it occupy the uppermost part
      right_bound = w*3 # big enough to ensure it occupy the rightmost part 
      left_bound = -100 # small enough to ensure it occupy the leftmost part
      output$mainPlot <- renderPlot({    
        plot(weight_range, bmi, xlab=x_label, ylab="BMI")
        # draw three vertical lines
        abline(v=ob, col="red")
        text(ob,0,ob)
        abline(v=ov, col="blue")
        text(ov,0,ov)
        abline(v=no, col="purple")
        text(no,0,no)
        
        rect(left_bound, lower_bound, no, upper_bound, col= '#F7FA0022', border = "transparent")
        rect(no, lower_bound, ov, upper_bound, col= '#00F7FA22', border = "transparent")
        rect(ov, lower_bound, ob, upper_bound, col= '#EFA2A122', border = "transparent")
        rect(ob, lower_bound, right_bound, upper_bound, col= '#BD211F22', border = "transparent")
        
        y_val = round(calculateBMI(w,h),2)
        if(input$weight_unit=='pounds')
          y_val = round(calculateBMI(w,h)/POUNDS_TO_KG ,2)
        
        
        label = paste('(', as.character(w), ',',as.character(y_val),')', sep="")
        text(w,y_val-5,label) # -5 to avoid overlap
        points(w,y_val, bg='blue', pch=21, cex=3, lwd=3)
        
        label = paste('(',as.character(no), ',',18.5,')', sep="")
        text(no,18.5+3,label) # +3 to avoid overlap
        label = paste('(',as.character(ov), ',',25,')', sep="")
        text(ov,25+3,label) # +3 to avoid overlap
        label = paste('(',as.character(ob), ',',30,')', sep="")
        text(ob,30+3,label) # +3 to avoid overlap
        
      })    
      
      })
    
  }  
)
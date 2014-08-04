library(shiny)
shinyUI(pageWithSidebar(

  headerPanel("BMI (Body Mass Index) Calculator"),
  sidebarPanel(
    h4('Please select your height and weight:'),
    conditionalPanel(
      condition = "input.height_unit == 'm'",
      sliderInput('height', 'Height (m)',value = 1.70, min = 1, max = 2, step = 0.01,)
    ),  
    conditionalPanel(
      condition = "input.height_unit == 'f'",
      sliderInput('height_feet', 'feet',value = 5, min = 3, max = 7, step = 1,),
      sliderInput('height_inch', 'inches',value = 7, min = 0, max = 11, step = 1,)
    ),
    radioButtons("height_unit","",c("m"="m","feet"="f")),
    
    conditionalPanel(
      condition = "input.weight_unit == 'kg'",
      sliderInput('weight', 'Weight (kg)',value = 60, min = 10, max = 150, step = 1,)
    ),  
    conditionalPanel(
      condition = "input.weight_unit == 'pounds'",
      sliderInput('weight2', 'Weight (pounds)',value = 130, min = 22, max = 330, step = 2,)
    ),
    radioButtons("weight_unit","",c("kg"="kg","pounds"="pounds"))

  ),
  mainPanel(
    tabsetPanel( id="tabs",
      
      tabPanel("Result", value="result", 
               h3('Your BMI is:'),
               textOutput('bmi'),
               h3('Level:'),
               textOutput('result')),
      tabPanel("Graph", value="plot", 
               h4('Weight Loss/Gain Calculator'),
               p('The BMI category you will reach after weight loss/gain.'), 
               p('Yellow area: Underweight'), 
               p('Blue area: Normal weight'),
               p('Light-red area: Overweight'), 
               p('Red area: Obesity'),
               p('The blue point indicates your current position'),
               plotOutput("mainPlot")),
      tabPanel("Documentation", value="Table",     
               h3('Description'),
               h4('Step 1. Input'),
               p('Use the slider to indicate your height (select m or feet as unit in radio button)'),
               p('and weight (select kg or pounds as unit in radio button)'),
               h4('Step 2. Ouput'),
               p('Result tab shows the BMI category you currently belong to'),
               p('Graph tab shows the BMI category you will achieve after weight gain/loss (assume the height does not change)'),
               h3('Formula'),
               p('BMI = Weight (in kg)/Height^2 (in m)'),
               code('w/(h*h)'),
               h3('BMI Categories'),
               p('Underweight = <18.5'),
               p('Normal weight = 18.5–24.9'),    
               p('Overweight = 25–29.9'),
               p('Obesity = BMI of 30 or greater'),
               p(''),
               h5("Reference:", a("CDC", href="http://www.cdc.gov/healthyweight/assessing/bmi/adult_bmi/index.html?s_cid=tw_ob064"))
               ) 
    )         

  )
))
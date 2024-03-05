import base64
import vertexai
from vertexai.preview.generative_models import GenerativeModel, Part
import vertexai.preview.generative_models as generative_models

def generate():
  vertexai.init(project="syncopated-1694942461775", location="northamerica-northeast1")
  model = GenerativeModel("gemini-1.0-pro-vision-001")
  responses = model.generate_content(
    ["""// Find center for a region def Find_Center(r) D = DT (r) // Run distance transform c = arg max(D) // Find maxium location return c // The main function def Mark_Allocation(R): R̂ = Sorted(R) // Sort regions in ascending order of areas for k in range(K): do rk = R̂[k] & ¬R̂[: k − 1].sum(0) // Exclude k − 1 regions C[k] = Find_Center(rk ) end return C //

exhaustively tell the categories for all marked regions and the categories that are selected in the assessment. « Referring Segmentation: Given a referring expression, the task is selecting the top-matched region from the candidates produced when applying the Find_Center function

Describe with intricate artistic  detail how the categories related to an overall theme""", image1],
    generation_config={
        "max_output_tokens": 2048,
        "temperature": 0.2,
        "top_p": 1,
        "top_k": 32
    },
    safety_settings={
        generative_models.HarmCategory.HARM_CATEGORY_HATE_SPEECH: generative_models.HarmBlockThreshold.BLOCK_ONLY_HIGH,
        generative_models.HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: generative_models.HarmBlockThreshold.BLOCK_ONLY_HIGH,
        generative_models.HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: generative_models.HarmBlockThreshold.BLOCK_ONLY_HIGH,
        generative_models.HarmCategory.HARM_CATEGORY_HARASSMENT: generative_models.HarmBlockThreshold.BLOCK_ONLY_HIGH,
    },
      )

  print(responses)

image1 = ImageFile

generate()

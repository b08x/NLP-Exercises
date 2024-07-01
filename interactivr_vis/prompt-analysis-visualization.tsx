import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";

const PromptAnalysisVisualization = () => {
  const [input, setInput] = useState('');
  const [currentStep, setCurrentStep] = useState(0);
  const [output, setOutput] = useState('');
  const [analysis, setAnalysis] = useState([]);
  const [workingPrompt, setWorkingPrompt] = useState('');
  const [explanation, setExplanation] = useState('');
  const [isAutoPlay, setIsAutoPlay] = useState(false);
  const [intervalId, setIntervalId] = useState(null);

  const colors = [
    'bg-red-100', 'bg-blue-100', 'bg-green-100', 'bg-yellow-100', 
    'bg-purple-100', 'bg-pink-100', 'bg-indigo-100', 'bg-orange-100', 'bg-teal-100'
  ];

  const steps = [
    {
      action: "Correlate discourse semantics",
      details: "Identify interconnections and functional relationships within the text",
      explanation: "This step involves analyzing how different parts of the text relate to each other, forming a coherent message.",
      simulate: (text) => {
        const keyPhrases = text.match(/\b(\w+(?:\s+\w+){0,3})\b/g)?.slice(0, 3) || [];
        return `Key phrases identified: ${keyPhrases.join(', ')}`;
      }
    },
    {
      action: "Identify pragmatic grammar",
      details: "Determine the intended communicative goal",
      explanation: "Here, we try to understand the overall purpose of the prompt - what it's trying to achieve.",
      simulate: (text) => {
        const intents = ['inform', 'request', 'persuade', 'express'];
        return `Likely intent: ${intents[Math.floor(Math.random() * intents.length)]}`;
      }
    },
    {
      action: "Analyze functional grammar",
      details: "Identify elements and their functions, cross-reference with pragmatic grammar",
      explanation: "This step breaks down the grammatical structure and relates it to the communicative goal.",
      simulate: (text) => {
        const words = text.split(' ').slice(0, 5);
        const pos = ['noun', 'verb', 'adjective', 'adverb', 'preposition'];
        return words.map(word => `${word} (${pos[Math.floor(Math.random() * pos.length)]})`).join(', ');
      }
    },
    {
      action: "Remove unnecessary adjuncts and qualifiers",
      details: "Streamline the prompt by removing non-essential modifiers",
      explanation: "This step focuses on removing words that don't significantly change the core meaning of the prompt.",
      simulate: (text) => {
        return text.split(' ').filter(() => Math.random() > 0.2).join(' ');
      }
    },
    {
      action: "Eliminate low information density text spans",
      details: "Remove parts with low thematic progression and textual coherence",
      explanation: "Here, we remove sections that don't contribute much to the overall message or flow of the prompt.",
      simulate: (text) => {
        return text.split('. ').filter((_, i) => i % 2 === 0).join('. ');
      }
    },
    {
      action: "Articulate condensation rationale",
      details: "Explain the reasons behind the condensation decisions",
      explanation: "This step involves reflecting on and explaining why certain parts were kept or removed.",
      simulate: (text) => {
        return "Removed redundant phrases and simplified complex structures while maintaining core message.";
      }
    },
    {
      action: "Condense prompt",
      details: "Optimize lexical choices; ensure preservation of context",
      explanation: "The final condensation step, where we make word choices that convey the most meaning in the least space.",
      simulate: (text) => {
        return text.split(' ').filter(() => Math.random() > 0.5).join(' ');
      }
    },
    {
      action: "Describe lexicogrammatical features",
      details: "Analyze the linguistic characteristics of the condensed output",
      explanation: "This step involves examining the grammatical and lexical features of our condensed prompt.",
      simulate: (text) => {
        const wordCount = text.split(' ').length;
        return `Word count: ${wordCount}. Simplified sentence structures with key terms preserved.`;
      }
    },
    {
      action: "Output condensed prompt",
      details: "Present the final, condensed version of the prompt",
      explanation: "The final step where we present our condensed, optimized prompt.",
      simulate: (text) => text
    }
  ];

  useEffect(() => {
    setWorkingPrompt(input);
    setOutput('');
    setAnalysis([]);
    setCurrentStep(0);
  }, [input]);

  useEffect(() => {
    if (isAutoPlay && currentStep < steps.length) {
      const id = setInterval(processStep, 3000);
      setIntervalId(id);
    } else {
      clearInterval(intervalId);
      setIntervalId(null);
    }

    return () => {
      if (intervalId) clearInterval(intervalId);
    };
  }, [isAutoPlay, currentStep]);

  const processStep = () => {
    if (currentStep < steps.length) {
      const step = steps[currentStep];
      const simulationResult = step.simulate(workingPrompt);
      setAnalysis(prevAnalysis => [...prevAnalysis, `Step ${currentStep + 1}: ${step.action}\n${step.details}\nResult: ${simulationResult}`]);
      setExplanation(step.explanation);
      setWorkingPrompt(simulationResult);
      
      if (currentStep === steps.length - 1) {
        setOutput(simulationResult);
        setIsAutoPlay(false);
      }
      
      setCurrentStep(prevStep => prevStep + 1);
    } else {
      setIsAutoPlay(false);
    }
  };

  const resetProcess = () => {
    setCurrentStep(0);
    setOutput('');
    setAnalysis([]);
    setWorkingPrompt(input);
    setExplanation('');
    setIsAutoPlay(false);
  };

  const toggleAutoPlay = () => {
    setIsAutoPlay(!isAutoPlay);
  };

  return (
    <div className="p-4 max-w-4xl mx-auto">
      <Card>
        <CardHeader>
          <CardTitle>Improved Prompt Analysis Visualization</CardTitle>
        </CardHeader>
        <CardContent>
          <Textarea
            placeholder="Enter prompt to analyze..."
            value={input}
            onChange={(e) => setInput(e.target.value)}
            className="mb-4"
          />
          <div className="flex justify-between items-center mb-4">
            <div>
              <Button onClick={processStep} disabled={currentStep >= steps.length || isAutoPlay}>
                {currentStep >= steps.length ? 'Process Complete' : 'Next Step'}
              </Button>
              <Button onClick={resetProcess} variant="outline" className="ml-2">
                Reset
              </Button>
            </div>
            <div className="flex items-center">
              <span className="mr-2">Auto-play</span>
              <Switch checked={isAutoPlay} onCheckedChange={toggleAutoPlay} />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <h3 className="font-bold mb-2">Analysis Steps</h3>
              <div className="bg-gray-100 p-2 rounded h-60 overflow-auto">
                {analysis.map((step, index) => (
                  <div key={index} className={`p-2 mb-2 rounded ${colors[index]}`}>
                    <pre className="whitespace-pre-wrap">{step}</pre>
                  </div>
                ))}
              </div>
            </div>
            <div>
              <h3 className="font-bold mb-2">Step Explanation</h3>
              <div className={`p-2 rounded h-60 overflow-auto ${colors[currentStep]}`}>
                <p>{explanation}</p>
              </div>
            </div>
          </div>
          <div className="mt-4 grid grid-cols-2 gap-4">
            <div>
              <h3 className="font-bold mb-2">Original Prompt</h3>
              <div className="bg-gray-100 p-2 rounded h-40 overflow-auto">
                <pre className="whitespace-pre-wrap">{input}</pre>
              </div>
            </div>
            <div>
              <h3 className="font-bold mb-2">Condensed Prompt</h3>
              <div className="bg-gray-100 p-2 rounded h-40 overflow-auto">
                <pre className="whitespace-pre-wrap">{output}</pre>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default PromptAnalysisVisualization;

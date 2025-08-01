@startuml
actor Client
participant "Load Balancer\n(Public IP)" as LB
participant "AKS Service" as AKS
participant "Azure AI Chatbot API" as AI

Client -> LB: HTTP request
LB -> AKS: Forward request
AKS -> AI: Call Chatbot API
AI --> AKS: Response
AKS --> LB: Response
LB --> Client: Response
@enduml

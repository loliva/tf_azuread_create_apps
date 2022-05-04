from diagrams import Diagram, Cluster
from diagrams.azure.identity import AppRegistrations, Users
import os

with Diagram("Azure AD" , show=False, direction="TB"):
    with Cluster("\n Example Organization Tenant \n815b68ce-cb41-11ec-b412-df4306cc141b"):
        [AppRegistrations("backend-{env}"),
         AppRegistrations("frontend-{env}")]

#!/usr/bin/env python
# coding: utf-8

# ## Import Packages

# In[71]:


import pandas as pd
import numpy as np


# ## Read in Data

# In[72]:


WB2019=pd.read_csv(r"C:\Users\nbroo\OneDrive\Documents\Data Science Final Group Project\Women In Business Before And After The Pandemic\2019 (2018) Census Business Data.csv")
WB2019.head()


# ## Drop Unwanted Columns

# In[73]:


WB2019.drop(['GEO_ID', 'GEO_ID_F', 'NAME', 'NAICS2017_F', 'INDLEVEL', 'NAICS2017_LABEL', 'INDGROUP', 'SECTOR', 'SUBSECTOR', 'SEX_LABEL', 'ETH_GROUP_LABEL', 'RACE_GROUP_LABEL', 'VET_GROUP_LABEL', 'QDESC','QDESC_LABEL', 'BUSCHAR', 'BUSCHAR_LABEL', 'YEAR', 'FIRMPDEMP','FIRMPDEMP_PCT', 'EMP_PCT', 'PAYANN','RCPPDEMP_PCT', 'PAYANN_PCT', 'FIRMPDEMP_S', 'FIRMPDEMP_PCT_S','RCPPDEMP_PCT_S', 'EMP_PCT_S', 'PAYANN_S', 'PAYANN_PCT_S'], axis = 1, inplace = True)
WB2019.head()


# ## Get Unique Values of Sex Column

# In[74]:


WB2019['SEX'].unique()


# ### Looks like we have two types of "2". Going to view the count of each

# In[75]:


WB2019.SEX.value_counts()


# ### Now adding them together.

# In[76]:


WB2019.SEX.value_counts().sum()


# ## Select only rows with the value of 2

# In[77]:


WB2019 = WB2019[(WB2019['SEX'].isin(['2', 2]))]


# ## Confirm that we have the correct number of rows

# In[78]:


WB2019.shape


# # Rename Columns

# In[79]:


WB2019_1 = WB2019.rename(columns={'NAICS2017':'NAICS',
                                       'SEX':'Owners_Sex',
                                       'ETH_GROUP': 'Owners_Ethnicity', 
                                       'RACE_GROUP':'Owners_Race', 
                                       'VET_GROUP':'Vet_Status', 
                                       'RCPPDEMP':'Sales', 
                                       'EMP': 'Employees', 
                                       'RCPPDEMP_S':'Sales_Std_Error', 
                                       'EMP_S':'Employees_Std_Error'})


# In[80]:


WB2019_1.head()


# # Convert datatype to integer

# In[81]:


WB2019_1.info()


# In[82]:


WB2019_2 = WB2019_1.apply(pd.to_numeric, errors='coerce')


# In[83]:


print(WB2019_2)


# In[84]:


WB2019_2.info()


# # Determine which sectors were predominantly female-owned:
# 

# In[85]:


WB2019_2.NAICS.value_counts()


# ## The following sectors were top 5 in 2019: (1) Professional/Scientific/Technical Services; (2) Health Care & Social Assistance; (3) Administrative and support and Waste Management and Remediation Services; (4) Wholesale Trade; and (5) Accommadtion & Food Services.

# In[ ]:





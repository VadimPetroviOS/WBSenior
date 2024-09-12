# DefaultAPI

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**characterGet**](DefaultAPI.md#characterget) | **GET** /character | Получение списка персонажей


# **characterGet**
```swift
    open class func characterGet(page: Int? = nil, name: String? = nil, status: String? = nil, species: String? = nil, gender: String? = nil, completion: @escaping (_ data: CharacterGet200Response?, _ error: Error?) -> Void)
```

Получение списка персонажей

Возвращает список персонажей из сериала \"Rick and Morty\".

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let page = 987 // Int | Номер страницы для пагинации (по умолчанию 1). (optional)
let name = "name_example" // String | Фильтровать персонажей по имени. (optional)
let status = "status_example" // String | Фильтровать персонажей по статусу (например, \"alive\", \"dead\", \"unknown\"). (optional)
let species = "species_example" // String | Фильтровать персонажей по виду (например, \"Human\", \"Alien\"). (optional)
let gender = "gender_example" // String | Фильтровать персонажей по полу (например, \"Male\", \"Female\", \"Genderless\", \"Unknown\"). (optional)

// Получение списка персонажей
DefaultAPI.characterGet(page: page, name: name, status: status, species: species, gender: gender) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Int** | Номер страницы для пагинации (по умолчанию 1). | [optional] 
 **name** | **String** | Фильтровать персонажей по имени. | [optional] 
 **status** | **String** | Фильтровать персонажей по статусу (например, \&quot;alive\&quot;, \&quot;dead\&quot;, \&quot;unknown\&quot;). | [optional] 
 **species** | **String** | Фильтровать персонажей по виду (например, \&quot;Human\&quot;, \&quot;Alien\&quot;). | [optional] 
 **gender** | **String** | Фильтровать персонажей по полу (например, \&quot;Male\&quot;, \&quot;Female\&quot;, \&quot;Genderless\&quot;, \&quot;Unknown\&quot;). | [optional] 

### Return type

[**CharacterGet200Response**](CharacterGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


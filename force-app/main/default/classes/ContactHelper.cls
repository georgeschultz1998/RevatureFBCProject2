public class ContactHelper {
	public static void checkEmail(List<Contact> conList){
        // Get Account IDS
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : conList) {
            accountIds.add(con.AccountId);
        }

        // Get all contacts related to Accounts and map it
        Map<Id, List<Contact>> accountToContactsMap = new Map<Id, List<Contact>>();
        for(Contact con : [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN :accountIds]) {
            if(!accountToContactsMap.containsKey(con.AccountId)) {
                accountToContactsMap.put(con.AccountId, new List<Contact>());
            }
            accountToContactsMap.get(con.AccountId).add(con);
        }

        for(Contact con : conList) {
            if(accountToContactsMap.containsKey(con.AccountId)) {
                String newEmailDomain = '';
                for(Contact relatedContact : accountToContactsMap.get(con.AccountId)) {
                    if(relatedContact.Id != con.Id) {
                        String relatedEmailDomain = '';
                        if(!String.isBlank(relatedContact.Email)){
                        	relatedEmailDomain = relatedContact.Email.substringAfter('@');   
                        }
                        if(!String.isBlank(con.Email)){
                            newEmailDomain = con.Email.substringAfter('@');
                        } else {
                            newEmailDomain = 'this is an example';
                        }
                        if(newEmailDomain != relatedEmailDomain && newEmailDomain != 'this is an example' && relatedEmailDomain != '') {
                            con.addError('Must be the same Domain as Account');
                        }
                    }
                }
            }
        }
    }
}
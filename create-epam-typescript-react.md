
## 1. create project 

	npx create-react-app my-app --template typescript
	
## 2. add .yarnrc file in root folder and past there this text:

	registry "https://registry.npmjs.org/"
	"@epam:registry" "https://artifactory.epam.com/artifactory/api/npm/shared-npm/"
	
## 3. npm login -registry https://artifactory.epam.com/artifactory/api/npm/shared-npm/

	login: shared-npm
	password: shared-npm
	email: any (e.g. shared-npm@epam.com)

## 4. add other library

	yarn add @epam/loveship @epam/uui @epam/uui-components @epam/assets
	yarn add react-router-dom @types/react-router-dom
	yarn add node-sass
	
## 5. if you want to use notification, modal and other contexts, you must :

	### create file services.ts with next code:	
	
	```javascript
	import { CommonContexts } from '@epam/uui';
	export interface SandboxServices extends CommonContexts<any, any> {}
	export const svc: SandboxServices = {} as any;
	```

	### in main index.tsx file wrap your <App/> component into <ContextProvider>, and add <Snackbar /> after <App/>
	
	```javascript
	import { ContextProvider } from "@epam/uui";
	import * as _ from "lodash";
	import { svc } from "./services";
	import { BrowserRouter as Router, withRouter } from "react-router-dom";
	import { Snackbar, Modals } from "@epam/uui-components";


	const UuiEnhancedApp = withRouter(({ history }) => (
	  <ContextProvider
		apiDefinition={() => null}
		loadAppContext={() => Promise.resolve({})}
		onInitCompleted={(context) => {
		  _.assign(svc, context);
		}}
		history={history}
	  >
		<App />
		<Snackbar />
		<Modals />
	  </ContextProvider>
	));
	
	const RoutedApp = () => (
		<Router>
			<UuiEnhancedApp />
		</Router>
	)


	ReactDOM.render(<RoutedApp />, document.getElementById('root'));
	
	```
	
import { useState } from 'react';
import { I18nProvider } from '@/lib/I18nContext';
import { HomePage } from '@/components/HomePage';
import { FarmerPortal } from '@/components/FarmerPortal';
import { CentrePortal } from '@/components/CentrePortal';
import { GovernmentPortal } from '@/components/GovernmentPortal';
import type { Portal } from '@/types';

function App() {
  const [portal, setPortal] = useState<Portal>('home');

  return (
    <I18nProvider>
      {portal === 'home' && <HomePage onNavigate={setPortal} />}
      {portal === 'farmer' && <FarmerPortal onHome={() => setPortal('home')} />}
      {portal === 'centre' && <CentrePortal onHome={() => setPortal('home')} />}
      {portal === 'government' && <GovernmentPortal onHome={() => setPortal('home')} />}
    </I18nProvider>
  );
}

export default App;
